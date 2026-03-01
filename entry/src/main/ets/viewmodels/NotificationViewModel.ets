import { fetchFixturesByDate } from '../repository/AppRepository';
import { BusinessError } from '@kit.BasicServicesKit';
import { preferences } from '@kit.ArkData';
import { PreferencesService } from '../services/PreferencesService';
import { TeamUIModel } from '../models/teams/TeamsApiTypes';
import { Constants } from '../common/utils/Constants';
import { reminderAgentManager } from '@kit.BackgroundTasksKit';
import { notificationManager } from '@kit.NotificationKit';
import { FixtureListItem } from '../models/fixtures/FixturesListItem';
import { NotificationService } from '../services/NotificationService';

@Observed
export class NotificationViewModel {
  private timer1: number | undefined = undefined;
  private notiFlag :boolean = false;
  private startMatchTicker(timeToInterval: number, fixtureId: number): void {
    this.timer1 = setInterval(() => {
      if (this.notiFlag) {
        NotificationService.triggerSimpleNotification(fixtureId);
      }
    }, timeToInterval) as number;
  }

  private pref: preferences.Preferences = PreferencesService.getInstance().getPref();
  team: TeamUIModel | null = this.getTeam();

  getCurrentDate(): string {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  getData() {
    fetchFixturesByDate(this.getCurrentDate())
      .then(list => {
        for (let index = 0; index < list.length; index++) {
          const element = list[index];
          if (this.team !== null) {
            let teamName = this.team?.name;
            if (element.teams.home.name === teamName || element.teams.away.name === teamName) {
              if (element.fixture.status.short === 'NS') {
                setAlarmToMatch(element);
              }
              else if (element.fixture.status.short === 'LIVE' || element.fixture.status.short === '2H' || element.fixture.status.short === '1H' )
              {
                this.notiFlag = true;
                this.startMatchTicker(60000, element.fixture.id);
              }
              else if (element.fixture.status.long === 'Match Finished')
              {
               this.notiFlag = false;
              }
            }
          }
        }
      })
      .catch((e: BusinessError) => {
        return 0;
      });
  }

  private getTeam(): TeamUIModel | null {
    const json = this.pref.getSync(Constants.TEAM_KEY, '') as string;
    if (!json) {
      return null;
    }
    try {
      const obj = JSON.parse(json) as TeamUIModel;
      if (!obj?.id || !obj?.name) {
        return null;
      }
      return obj;
    } catch {
      return null;
    }
  }
}

function setAlarmToMatch(fixture: FixtureListItem) {
  let date = new Date(fixture.fixture.timezone);
  let targetReminderAgent: reminderAgentManager.ReminderRequestCalendar = {
    reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_CALENDAR,
    dateTime: {
      year: date.getFullYear(),
      month: date.getMonth(),
      day: date.getDay(),
      hour: date.getHours(),
      minute: date.getMinutes(),
      second: date.getSeconds()
    },
    repeatMonths: [1],
    repeatDays: [1],
    actionButton: [
      {
        title: 'close',
        type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_CLOSE
      }
    ],
    wantAgent: {
      pkgName: 'com.hmosdemos.wearable.goal_pulse',
      abilityName: 'EntryAbility'
    },
    ringDuration: 5,
    title: `${fixture.teams.home.name} - ${fixture.teams.away.name} the match is about to start`,
    content: `${fixture.teams.home.name} - ${fixture.teams.away.name} the match is about to start`,
    expiredContent: 'this reminder has expired',
    notificationId: fixture.fixture.id,
    slotType: notificationManager.SlotType.SOCIAL_COMMUNICATION
  };

  let reminderId: number = fixture.fixture.id;
  reminderAgentManager.cancelReminder(reminderId).then(() => {
    console.info('Succeeded in canceling reminder.');
  }).catch((err: BusinessError) => {
    console.error(`Failed to cancel reminder. Code: ${err.code}, message: ${err.message}`);
  });
  reminderAgentManager.publishReminder(targetReminderAgent).then(() => {
    console.info('Succeeded in publishing reminder. ');
  }).catch((err: BusinessError) => {
    console.error(`Failed to publish reminder. Code: ${err.code}, message: ${err.message}`);
  });
  throw new Error('Function not implemented.');
}

