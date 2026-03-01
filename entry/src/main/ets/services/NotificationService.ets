import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { fetchFixtureByID } from '../repository/AppRepository';
import { FixtureDetailItem, FixtureEvent } from '../models/fixtures/FixtureApiTypes';

const TAG: string = '[PublishOperation]';
const DOMAIN_NUMBER: number = 0xFF00;
let listOfFixture : FixtureDetailItem[];

export class NotificationService {
  static async triggerSimpleNotification(fixtureId: number): Promise<void> {
    fetchFixtureByID(fixtureId)
      .then(list => {
        let fx = list[0];
        if (fx.events.length > listOfFixture.length) {
          for (let index = listOfFixture.length; index < fx.events.length; index++) {
            sendEventToNotify(fx.events[index])
          }
          listOfFixture = list;
        }
      })
      .catch((e: BusinessError) => {
        return 0;
      });
  }
}
function sendEventToNotify(event : FixtureEvent) {
  let title : string = '';
  let content : string = '';

  if (event.type === 'Goal') {
    title = 'Goall!!';
  } else if (event.detail === 'Yellow Card') {
    title = 'Yellow Card';
  } else if (event.detail === 'Red card') {
    title = 'Red Card';
  } else if (event.type === 'Var') {
    title = 'Var';
  }
  content = event.detail.toString()
  const notificationRequest: notificationManager.NotificationRequest = {
    content: {
      notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
      normal: {
        title: (title),
        text: (content)
      }
    }
  };
  notificationManager.publish(notificationRequest, (err: BusinessError) => {
    if (err) {
      hilog.error(DOMAIN_NUMBER, TAG,
        `Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
      return;
    }
    hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in publishing notification.');
  });
}
