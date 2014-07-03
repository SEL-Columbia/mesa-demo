s = RJSONIO::fromJSON("~/Code/mesamaps/data/manhattan.geo.json")

### Looking at the data
print(s$features[[1]])
print(s$features[[1]]$properties)
table(sapply(s$features, function(f) { f$geometry$type }))

## Pluck out just the highways
t <- s
t$features <- Filter(function(x) { x$geometry$type == 'LineString'},
                     t$features)
t$features <- Filter(function(x) { 
    'highway' %in% names(x$properties) &&
        str_detect(x$properties[['highway']], 'ary|mot|res|run|unc')},
    t$features)

## Drop all the features but name & highway
## and add random congestion_level and total_flow
t$features <- llply(t$features, function(f) {
    f$properties <- list(
        name = ifelse('name' %in% names(f$properties),
                      f$properties[['name']],
                      'Unnamed'),
        highway = ifelse('highway' %in% names(f$properties),
                         f$properties[['highway']],
                         'None'),
        congestion_level = sample(c("Moderate", "Low", "High"), 1),
        total_flow = round(runif(1, min=100, max=50000))
    )
    f
})
write(RJSONIO::toJSON(t, collapse="", pretty=FALSE, digits=9),
      '~/Code/mesamaps/data/manhattan_mod.geo.json')
