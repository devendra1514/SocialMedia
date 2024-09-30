# frozen_string_literal: true

# Pagy::DEFAULT[:limit]       = 20                    # default
# Pagy::DEFAULT[:size]        = 7                     # default
# Pagy::DEFAULT[:ends]        = true                  # default
# Pagy::DEFAULT[:page_param]  = :page                 # default
# Pagy::DEFAULT[:count_args]  = []                    # example for non AR ORMs
# Pagy::DEFAULT[:max_pages]   = 3000                  # example


# require 'pagy/extras/size'   # must be required before the other extras

# require 'pagy/extras/arel'

# require 'pagy/extras/array'

# require 'pagy/extras/calendar'
# >> Pagy::Calendar::Year::DEFAULT
# >> Pagy::Calendar::Quarter::DEFAULT
# >> Pagy::Calendar::Month::DEFAULT
# >> Pagy::Calendar::Week::DEFAULT
# >> Pagy::Calendar::Day::DEFAULT
#
# module LocalizePagyCalendar
#   def localize(time, opts)
#     ::I18n.l(time, **opts)
#   end
# end
# Pagy::Calendar.prepend LocalizePagyCalendar

# require 'pagy/extras/countless'
# Pagy::DEFAULT[:countless_minimal] = false   # default (eager loading)

# Pagy::DEFAULT[:elasticsearch_rails_pagy_search] = :pagy_search
# Pagy::DEFAULT[:elasticsearch_rails_search] = :search
# require 'pagy/extras/elasticsearch_rails'

# require 'pagy/extras/headers'
# Pagy::DEFAULT[:headers] = { page: 'Current-Page',
#                            limit: 'Page-Items',
#                            count: 'Total-Count',
#                            pages: 'Total-Pages' }     # default

# require 'pagy/extras/keyset'

# Pagy::DEFAULT[:meilisearch_pagy_search] = :pagy_search
# Pagy::DEFAULT[:meilisearch_search] = :ms_search
# require 'pagy/extras/meilisearch'

# require 'pagy/extras/js_tools'
# require 'pagy/extras/metadata'
# Pagy::DEFAULT[:metadata] = %i[scaffold_url page prev next last]   # example

# Pagy::DEFAULT[:searchkick_pagy_search] = :pagy_search
# Pagy::DEFAULT[:searchkick_search] = :search
# require 'pagy/extras/searchkick'
# Searchkick.extend Pagy::Searchkick


# See https://ddnexus.github.io/pagy/docs/extras/bootstrap
# require 'pagy/extras/bootstrap'

# require 'pagy/extras/bulma'

# require 'pagy/extras/pagy'

# Pagy::DEFAULT[:steps] = { 0 => 5, 540 => 7, 720 => 9 }   # example


# require 'pagy/extras/gearbox'
# Pagy::DEFAULT[:gearbox_extra] = false               # default true
# Pagy::DEFAULT[:gearbox_limit] = [15, 30, 60, 100]   # default

require 'pagy/extras/limit'
# Pagy::DEFAULT[:limit_extra] = false    # default true
Pagy::DEFAULT[:limit_param] = :per_page   # default
Pagy::DEFAULT[:limit_max]   = 50      # default

require 'pagy/extras/overflow'
Pagy::DEFAULT[:overflow] = :empty_page    # default  (other options: :last_page and :exception)

# require 'pagy/extras/trim'
# Pagy::DEFAULT[:trim_extra] = false # default true

# require 'pagy/extras/standalone'
# Pagy::DEFAULT[:url] = 'http://www.example.com/subdir'  # optional default

# require 'pagy/extras/jsonapi'   # must be required after the other extras
# Pagy::DEFAULT[:jsonapi] = false  # default true

# Rails.application.config.assets.paths << Pagy.root.join('javascripts')

# Pagy::I18n.load(locale: 'de')
#
# Pagy::I18n.load(locale: 'de', filepath: 'path/to/pagy-de.yml')
#
# Pagy::I18n.load({ locale: 'de' },
#                 { locale: 'en' },
#                 { locale: 'es' })
#
# Pagy::I18n.load({ locale: 'en' },
#                 { locale: 'es', filepath: 'path/to/pagy-es.yml' },
#                 { locale: 'xyz',  # not built-in
#                   filepath: 'path/to/pagy-xyz.yml',
#                   pluralize: lambda{ |count| ... } )


# require 'pagy/extras/i18n'

Pagy::DEFAULT.freeze
