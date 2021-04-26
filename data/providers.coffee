# import snarkdown from 'snarkdown'

import { Remarkable } from 'remarkable'
md = new Remarkable()

regionsForPostalCode = (postal_code='')->
  switch postal_code[0].toUpperCase()
    when 'A' then ['NL']
    when 'B' then ['NS']
    when 'C' then ['PE']
    when 'E' then ['NB']
    when 'G', 'H', 'J' then ['QC']
    when 'K', 'L', 'M', 'N', 'P' then ['ON']
    when 'R' then ['MB']
    when 'S' then ['SK']
    when 'T' then ['AB']
    when 'V' then ['BC']
    when 'X' then ['NU', 'NT']
    when 'Y' then ['TY']

# # prio groups
# ltc = "Residents, staff and essential caregivers in long-term care homes"
# al = "Residents and staff in other congregate care settings for seniors, including all other retirement homes and assisted living"
# frontline = "Frontline health care workers in all risk groups"
# homecare = "Adults who are receiving ongoing home care"
# indigenous = "First Nations, Métis, or Inuit people"
# high_risk_health = """
#   People with the following highest-risk health conditions:
#   - Organ transplant recipients
#   - Hematopoietic stem cell transplant recipients
#   - People with neurological diseases in which respiratory function may be compromised (e.g., motor neuron disease, myasthenia gravis, multiple sclerosis)
#   - Haematological malignancy diagnosed less than one year ago
#   - Kidney disease eGFR< 30
#   - Obesity (BMI > 40)
#   - Other treatments causing immunosuppression (e.g., chemotherapy, immunity weakening medications)
#   - Intellectual or developmental disabilities (e.g., Down Syndrome)
#   - One essential caregiver is eligible for vaccination for individuals in this group listed above. The caregiver provides regular and sustained assistance with personal care and/or activities of daily living.
# """

prio_postal_codes = """
  L1S L1T L1V L1X L1Z
  L9E
  L8W L9C
  K1T K1V K2V
  L4T L4W L4X L4Z L5A L5B L5R L5C L5K L5L L5M L5N L5V L5W L6P L6R L6S L6T L7C L6V L6W L6X L6Y L6Z L7A
  L3Z
  N2C
  N1K
  N8X N8Y N9A N9B N9C N8H N9Y
  L0J L4B L4E L4H L4J L4K L4L L6A L3S L3T L6B L6C L6E
  M1B M1C M1E M1G M1H M1J M1K M1M M1P M1R M1X M1L M4H M1S M1T M1V M1W M2J M2M M2R M3A M3C M3H M4A M3J M3K M3L M3M M3N M6B M6L M6M M9L M9M M9N M9P M4X M5A M5B M5N M6A M5V M6E M6H M6K M6N M8V M9A M9B M9C M9R M9V M9W
  N5H
""".split /\s+/

class Provider
  constructor: (attrs={})->
    for key, val of attrs
      val.bind @ if 'function' is typeof val
      @[key] = val

  match: ({postal_code=''})=>
    @region_code in regionsForPostalCode postal_code

  filter: (attrs)=>
    # exit immediately if any filters fail
    for name, fn of @ when /^filter_/.test name
      return false unless fn attrs

    # exit immediately if any selects pass
    for name, fn of @ when /^select_/.test name
      return true if fn attrs

    # default to true
    true

  filter_age: ({birth_year}={})=>
    @min_age and birth_year and @min_age <= (2021 - birth_year)

class Province extends Provider

class Pharmacy extends Provider

class Clinic extends Provider


export default [

  # BC
  # https://www2.gov.bc.ca/gov/content/covid-19/vaccine
  new Province({
    region_code: 'BC'
    name: 'BC Health Care System'
    booking_url: 'https://www2.gov.bc.ca/gov/content/covid-19/vaccine/register'
    min_age: 18
    updated_at: '2021-04-24'
  })
,
  new Pharmacy({
    region_code: 'BC'
    name: 'Select Pharmacies'
    description: md.render """
      Many pharmacies in BC are participating in vaccination programs.
    """
    booking_url: 'https://www2.gov.bc.ca/gov/content/covid-19/vaccine/pharmacy'
    min_age: 40
    updated_at: '2021-04-20'
  })
,

  # AB
  # https://www.albertahealthservices.ca/topics/page17295.aspx
  new Province({
    region_code: 'AB'
    name: 'Alberta Health Services'
    description: md.render """
      Calgary and Edmonton residents 55+ may also be eligible.
    """
    booking_url: 'https://myhealth.alberta.ca/Journey/Immunization/Pages/CovidImmPubTool.aspx'
    min_age: 40
    updated_at: '2021-04-26'
  })
,
  new Pharmacy({
    region_code: 'AB'
    name: 'Select Pharmacies'
    description: md.render """
      Many pharmacies in Alberta are participating in vaccination programs.
    """
    booking_url: 'https://www.ab.bluecross.ca/news/covid-19-immunization-program-information.php'
    min_age: 40
    updated_at: '2021-04-20'
  })
,

  # SK
  # https://www.saskatchewan.ca/COVID19-vaccine.
  new Province({
    region_code: 'SK'
    name: 'Saskatchewan Health Authority'
    booking_url: 'https://www.saskatchewan.ca/government/health-care-administration-and-provider-resources/treatment-procedures-and-guidelines/emerging-public-health-issues/2019-novel-coronavirus/covid-19-vaccine/vaccine-booking#check-your-eligibility'
    description: """
      40 YEARS OF AGE AND OLDER in the Northern Saskatchewan Administration District
    """
    min_age: 44
    updated_at: '2021-04-26'
  })
,
  new Clinic({
    region_code: 'SK'
    name: 'Drive-Thru and Walk-in Clinics'
    info_url: 'https://www.saskhealthauthority.ca/news/service-alerts-emergency-events/Pages/COVID-19-Vaccine-Drive-Thru-Wait-Times.aspx'
    description: """
      40 YEARS OF AGE AND OLDER in the Northern Saskatchewan Administration District
    """
    min_age: 44
    updated_at: '2021-04-26'
  })
,

  # MB
  # https://www.gov.mb.ca/covid19/vaccine/index.html
  new Province({
    region_code: 'MB'
    name: 'Super-Sites and Pop-up Clinics'
    info_url: 'https://www.gov.mb.ca/covid19/vaccine/eligibility-criteria.html#sites'
    min_age: 50
    updated_at: '2021-04-21'
  })
,
  new Pharmacy({
    region_code: 'MB'
    name: 'Medical Clinics and Pharmacies'
    description: md.render """
      Many clinics and pharmacies in Manitoba are participating in vaccination programs.
    """
    info_url: 'https://www.gov.mb.ca/covid19/vaccine/eligibility-criteria.html#clinics-pharmacies'
    min_age: 40
    updated_at: '2021-04-19'
  })
,

  # ON
  # https://covid-19.ontario.ca
  new Province({
    region_code: 'ON'
    name: 'Ontario Health Services'
    booking_url: 'https://covid-19.ontario.ca/book-vaccine/'
    min_age: 60
    updated_at: '2021-04-17'
  })
,
  new Pharmacy({
    region_code: 'ON'
    name: 'Select Pharmacies'
    description: md.render """
      Many pharmacies in Ontario are participating in vaccination programs.
    """
    booking_url: 'https://covid-19.ontario.ca/vaccine-locations'
    min_age: 40
    updated_at: '2021-04-20'
  })
,
  new Clinic({
    region_code: 'ON'
    name: 'Hot-Spot Mobile & Pop-up Vaccine Clinics'
    description: md.render """
      Mobile and pop-up clinics are planned for priority neighbourhoods and workplaces.

      These clinics will be promoted locally by community partners and public health units.

      Do not book through the provincial booking system.
    """
    info_url: 'https://covid-19.ontario.ca/ontarios-covid-19-vaccination-plan'
    min_age: 18
    filter_prio_postal_code: ({postal_code=''}={})->
      postal_code in prio_postal_codes
    updated_at: '2021-04-17'
  })
,

  # QC
  # https://www.quebec.ca/en/health/health-issues/a-z/2019-coronavirus/progress-of-the-covid-19-vaccination#c91977
  new Province({
    region_code: 'QC'
    name: 'Québec Health Services'
    info_url: 'https://www.quebec.ca/en/health/health-issues/a-z/2019-coronavirus/progress-of-the-covid-19-vaccination#c92384'
    min_age: 60
    updated_at: '2021-04-17'
  })
,
  new Clinic({
    region_code: 'QC'
    name: 'Vaccine Clinics'
    description: md.render """
      Clinics have been set up where people between 55 and 79 years of age can get the AstraZeneca vaccine. See the details for the vaccination clinic nearest to you.
    """
    info_url: 'https://www.quebec.ca/en/health/health-issues/a-z/2019-coronavirus/progress-of-the-covid-19-vaccination#c91979'
    min_age: 45
    updated_at: '2021-04-22'
  })
,

  # NB
  # https://www2.gnb.ca/content/gnb/en/corporate/promo/covid-19/nb-vaccine/Get-Vaccinated.html
  new Province({
    region_code: 'NB'
    name: 'New Brunswick Health Authority'
    booking_url: 'https://www.gnb.ca/nosearch/vacc/index-e.html'
    min_age: 65
    updated_at: '2021-04-21'
  })
,
  new Pharmacy({
    region_code: 'NB'
    name: 'Select Pharmacies'
    description: md.render """
      Many pharmacies in Ontario are participating in vaccination programs.
    """
    booking_url: 'https://www2.gnb.ca/content/gnb/en/corporate/promo/covid-19/nb-vaccine/Get-Vaccinated/vaccine-pharmacy.html'
    min_age: 65
    updated_at: '2021-04-21'
  })
,

  # NL
  # https://www.gov.nl.ca/covid-19/vaccine/gettheshot/
  new Province({
    region_code: 'NL'
    name: 'Newfoundland Health Authority'
    booking_url: 'https://www.gov.nl.ca/covid-19/vaccine/gettheshot/'
    min_age: 55
    updated_at: '2021-04-24'
  })
,

  # NS
  # https://novascotia.ca/coronavirus/book-your-vaccination-appointment/
  new Province({
    region_code: 'NS'
    name: 'Nova Scotia Health Authority'
    booking_url: 'https://novascotia.ca/coronavirus/book-your-vaccination-appointment/'
    min_age: 55
    updated_at: '2021-04-17'
  })
,

  # PE
  # https://www.princeedwardisland.ca/en/information/health-and-wellness/getting-covid-19-vaccine
  new Province({
    region_code: 'PE'
    name: 'PEI Health Authority'
    description: md.render """
      **Rollout schedule for 40-49 year olds**

      The first day of bookings is based on your birth month:

      - Monday: January – March
      - Tuesday: April - June
      - Wednesday: July - September
      - Thursday: October - December

      PEI also has several priority groups to which you may belong.

      Read more about PEI's [phase 2 rollout schedule](https://www.princeedwardisland.ca/en/information/health-and-wellness/covid-19-vaccines-and-immunization-phased-approach)
    """
    booking_url: 'https://www.princeedwardisland.ca/en/information/health-and-wellness/getting-covid-19-vaccine'
    info_url: 'https://www.princeedwardisland.ca/en/information/health-and-wellness/covid-19-vaccines-and-immunization-phased-approach'
    min_age: 40
    updated_at: '2021-04-26'
  })
,
  new Pharmacy({
    region_code: 'PE'
    name: 'Select Pharmacies'
    description: md.render """
      Many pharmacies in PEI are participating in vaccination programs.
    """
    info_url: 'https://www.princeedwardisland.ca/en/information/booking-your-covid-19-appointment-at-a-pharmacy'
    min_age: 55
    updated_at: '2021-04-26'
  })
,

]
