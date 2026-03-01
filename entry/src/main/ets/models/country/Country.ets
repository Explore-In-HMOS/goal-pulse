import { CountryItem } from './CountriesApiTypes';

export class Country {
  name: string;
  code: string;
  flag: string;

  constructor(name: string, code: string, flag: string) {
    this.name = name;
    this.code = code;
    this.flag = flag;
  }
}

export function parseCountry(item: CountryItem): Country {
  return new Country(
    item.name,
    item.code ?? '',
    item.flag ?? ''
  );
}

export function parseCountryList(items: CountryItem[]): Country[] {
  return items.map(parseCountry);
}
