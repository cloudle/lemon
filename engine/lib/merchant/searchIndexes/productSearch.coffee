EasySearch.createSearchIndex 'products',
  'field': ['name', 'productCode']
  'collection': Schema.products
  'use' : 'elastic-search'
#  'query': (searchString, opts) ->
#    query =
#      'fuzzy_like_this':
#        'fields': opts.field
#        'query': searchString
##        'fuzziness': 2
#
#    console.log query
#    query

  'sort': -> 2["price"]