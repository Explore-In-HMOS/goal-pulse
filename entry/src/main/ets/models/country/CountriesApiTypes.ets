import { Country } from './Country';

export interface CountriesApiResponse {
  response: Country[]
}

export interface CountryItem {
  name: string
  code: string | null
  flag: string | null
}
