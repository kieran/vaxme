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
      unless fn attrs
        console.log 'filtered'
        return false

    # exit immediately if any selects pass
    for name, fn of @ when /^select_/.test name
      return true if fn attrs

    # default to true
    true

  filter_age: ({birth_year}={})=>
    console.log @min_age, birth_year, (2021 - birth_year)
    @min_age and birth_year and @min_age <= (2021 - birth_year)

class Province extends Provider

class Pharmacy extends Provider

class Clinic extends Provider


export default [
  new Province({
    region_code: 'NL'
    name: 'Newfoundland'
    booking_url: ''
    min_age: 60
  })
,
  new Province({
    region_code: 'NS'
    name: 'Nova Scotia'
    booking_url: ''
    min_age: 60
  })
,
  new Province({
    region_code: 'ON'
    name: 'Ontario Health Care System'
    description: md.render """
      Several pharmacies in Ontario are participating in vannication programs.
    """
    booking_url: 'https://covid-19.ontario.ca/book-vaccine/'
    min_age: 60
    # priority_groups: {
    #   ltc
    #   al
    #   frontline
    #   homecare
    #   indigenous
    #   high_risk_health
    # }
  })
,
  new Pharmacy({
    region_code: 'ON'
    name: 'Select Pharmacies'
    description: md.render """
      Many pharmacies in Ontario are participating in vaccination programs.
    """
    booking_url: 'https://covid-19.ontario.ca/vaccine-locations'
    min_age: 55
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

  })
]
