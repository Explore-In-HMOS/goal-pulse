import { preferences } from '@kit.ArkData'
import { PreferencesService } from '../services/PreferencesService'
import { Constants } from '../common/utils/Constants'
import { TeamUIModel } from '../models/teams/TeamsApiTypes'
import {
  fetchLiveMatch
} from '../repository/AppRepository'
import { LiveMatchUIModel } from '../models/fixtures/FixturesApiTypes'

@Observed
export class LiveMatchViewModel {
  @Track team: TeamUIModel | null = null
  @Track liveMatch: LiveMatchUIModel | null = null
  @Track isLoading: boolean = false
  @Track errorMsg: string | null = null
  private pref: preferences.Preferences = PreferencesService.getInstance().getPref()
  private prevLength = 0
  private  lastEventIndex: number | null = null
  @Track newEventIndex: number | null = null

  init(): boolean {
    this.team = this.getTeam()
    if (!this.team) {
      this.errorMsg = 'No team selected'
      return false
    }
    return true
  }

  async loadAll(): Promise<void> {
    if (!this.team) {
      return
    }
    await this.loadLiveMatch(this.team.id)
  }

  async loadLiveMatch(teamId: number): Promise<void> {
    if (this.isLoading || !this.team) {
      return
    }

    this.isLoading = true
    try {
      const response = await fetchLiveMatch(this.team.id)
      if (response === undefined) {
        this.errorMsg = 'No live match'
        return
      }
      this.liveMatch = response
      const events = response?.events

      if (this.prevLength === 0) {
        this.prevLength = events.length
        this.lastEventIndex = events.length - 1
        return
      }

      if (events.length > this.prevLength &&
        this.lastEventIndex !== events.length - 1) {
        this.newEventIndex = events.length - 1
      }

      this.prevLength = events.length
      this.lastEventIndex = events.length - 1

    } finally {
      this.isLoading = false
    }
  }

  private getTeam(): TeamUIModel | null {
    const json = this.pref.getSync(Constants.TEAM_KEY, '') as string
    if (!json) {
      return null
    }
    try {
      const obj = JSON.parse(json) as TeamUIModel
      if (!obj?.id || !obj?.name) {
        return null
      }
      return obj
    } catch {
      return null
    }
  }
}
