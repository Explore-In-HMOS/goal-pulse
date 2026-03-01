import {
  FixtureDetailItem,
  FixtureEvent,
  FixtureTeamStatistics,
  MiniEventVM,
  StatItem
} from '../../models/fixtures/FixtureApiTypes';

export function safeNumToText(n: number | null): string {
  return n === null ? '-' : `${n}`;
}

export function lower(s: string | null): string {
  return (s ?? '').toLowerCase();
}

export function normalizeText(v: number | string | null): string {
  if (v === null) {
    return '-';
  }
  return `${v}`;
}

export function findTeamStats(stats: FixtureTeamStatistics[] | null, teamId: number): StatItem[] {
  if (!stats) {
    return [];
  }
  const t = stats.find(s => (s.team?.id ?? -1) === teamId);
  if (!t) {
    return [];
  }
  return t.statistics ?? [];
}

export function valueByType(items: StatItem[], type: string): number | string | null {
  const it = items.find(x => x.type === type);
  return it ? it.value : null;
}

export function isGoalEvent(e: FixtureEvent): boolean {
  return lower(e.type).includes('goal');
}

export function isCardEvent(e: FixtureEvent): boolean {
  return lower(e.type).includes('card');
}

export function cardIcon(e: FixtureEvent): string {
  const d = lower(e.detail);
  if (d.includes('red')) {
    return '🟥';
  }
  if (d.includes('yellow')) {
    return '🟨';
  }
  return '🟨';
}

export function goalExtraTag(e: FixtureEvent): string {
  const d = lower(e.detail);
  if (d.includes('own')) {
    return ' (OG)';
  }
  if (d.includes('pen')) {
    return ' (P)';
  }
  return '';
}

export function goalWhoText(e: FixtureEvent): string {
  const scorer = e.player?.name ?? 'Unknown';
  const assist = e.assist?.name ?? '';
  const tag = goalExtraTag(e);
  if (assist.length > 0) {
    return `${scorer}${tag} Assist: ${assist}`;
  }
  return `${scorer}${tag}`;
}

export function cardWhoText(e: FixtureEvent): string {
  return e.player?.name ?? 'Unknown';
}

export function buildTeamGoalVMs(events: FixtureEvent[] | null, teamId: number, prefix: string): MiniEventVM[] {
  if (!events || events.length === 0) {
    return [];
  }
  const out: MiniEventVM[] = [];

  events.forEach((e: FixtureEvent) => {
    if ((e.team?.id ?? -1) === teamId && isGoalEvent(e)) {
      const m = e.time.elapsed ?? 0;
      const minute = `${m}'`;
      const who = goalWhoText(e);
      const k = `${prefix}-${m}-goal-${who}`;
      out.push(new MiniEventVM(k, m, minute, '⚽', who));
    }
  });

  return out;
}

export function buildTeamCardVMs(events: FixtureEvent[] | null, teamId: number, prefix: string): MiniEventVM[] {
  if (!events || events.length === 0) {
    return [];
  }
  const out: MiniEventVM[] = [];

  events.forEach((e: FixtureEvent) => {
    if ((e.team?.id ?? -1) === teamId && isCardEvent(e)) {
      const m = e.time.elapsed ?? 0;
      const minute = `${m}'`;
      const who = cardWhoText(e);
      const icon = cardIcon(e);
      const k = `${prefix}-${m}-card-${icon}-${who}`;
      out.push(new MiniEventVM(k, m, minute, icon, who));
    }
  });

  return out;
}

export function isSubstEvent(e: FixtureEvent): boolean {
  return lower(e.type).includes('subst');
}

export function substWhoText(e: FixtureEvent): string {
  const outPlayer = e.player?.name ?? 'Unknown';
  const inPlayer = e.assist?.name ?? '';

  if (inPlayer.length > 0) {
    return `${outPlayer} → ${inPlayer}`;
  }
  return outPlayer;
}

export function buildTeamSubstVMs(events: FixtureEvent[] | null, teamId: number, prefix: string): MiniEventVM[] {
  if (!events || events.length === 0) {
    return [];
  }

  const out: MiniEventVM[] = [];

  events.forEach((e: FixtureEvent) => {
    if ((e.team?.id ?? -1) === teamId && isSubstEvent(e)) {
      const m = e.time.elapsed ?? 0;
      const minute = `${m}'`;
      const who = substWhoText(e);
      const k = `${prefix}-${m}-subst-${who}`;
      out.push(new MiniEventVM(k, m, minute, '🔁', who));
    }
  });

  return out;
}

export function mergeAndSort(goals: MiniEventVM[], cards: MiniEventVM[], substs: MiniEventVM[],
  prefix: string): MiniEventVM[] {
  const merged: MiniEventVM[] = [];
  goals.forEach(g => merged.push(g));
  cards.forEach(c => merged.push(c));
  substs.forEach(s => merged.push(s));

  merged.sort((a, b) => a.minuteNum - b.minuteNum);

  const out: MiniEventVM[] = [];
  merged.forEach((it, idx) => {
    out.push(new MiniEventVM(`${prefix}-${idx}-${it.key}`, it.minuteNum, it.minute, it.icon, it.who));
  });
  return out;
}

export function getTeamCodeFromName(name: string): string {
  const parts = name.trim().split(/\s+/);
  if (parts.length >= 2) {
    return `${parts[0].substring(0, 1)}${parts[1].substring(0, 1)}`.toUpperCase();
  }
  return name.substring(0, Math.min(3, name.length)).toUpperCase();
}

export function parseDate(d: string): Date | null {
  try {
    const dt = new Date(d);
    return isNaN(dt.getTime()) ? null : dt;
  } catch (_) {
    return null;
  }
}

const WEEKDAYS: string[] = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
const MONTHS: string[] = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

export function formatDateLine(d: string): string {
  const dt = parseDate(d);
  if (!dt) {
    return '';
  }
  return `${WEEKDAYS[dt.getDay()]}, ${MONTHS[dt.getMonth()]} ${dt.getDate()}`;
}

export function formatTimeLine(d: string): string {
  const dt = parseDate(d);
  if (!dt) {
    return '';
  }
  const hh = dt.getHours().toString().padStart(2, '0');
  const mm = dt.getMinutes().toString().padStart(2, '0');
  return `${hh}:${mm}`;
}

export function eventIcon(e: FixtureEvent): string {
  const t = lower(e.type);
  const d = lower(e.detail);
  if (t.includes('goal')) {
    return '⚽';
  }
  if (t.includes('card') && d.includes('yellow')) {
    return '🟨';
  }
  if (t.includes('card') && d.includes('red')) {
    return '🟥';
  }
  if (t.includes('subst')) {
    return '🔁';
  }
  return '•';
}

export class SplitGoals {
  left: FixtureEvent[];
  right: FixtureEvent[];

  constructor(left: FixtureEvent[], right: FixtureEvent[]) {
    this.left = left;
    this.right = right;
  }
}

export function splitGoalsByTeam(fx: FixtureDetailItem): SplitGoals {
  const homeId = fx.teams.home.id;
  const awayId = fx.teams.away.id;
  const goals = fx.events.filter(e => lower(e.type).includes('goal'));
  return new SplitGoals(
    goals.filter(e => e.team?.id === homeId),
    goals.filter(e => e.team?.id === awayId)
  );
}

export function statValue(stats: FixtureTeamStatistics[] | null, teamId: number, type: string): number | string | null {
  if (!stats) {
    return null;
  }
  const t = stats.find(s => (s.team?.id ?? -1) === teamId);
  if (!t) {
    return null;
  }
  const item = t.statistics.find(si => si.type === type);
  return item ? item.value : null;
}

export function normalizePercent(v: number | string | null): string {
  if (v === null) {
    return '-';
  }
  if (typeof v === 'number') {
    return `${v}%`;
  }
  return v.includes('%') ? v : `${v}%`;
}
