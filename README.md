This map uses fairly standard leaflet code to style a geo-json file (manhattan_mod.geo.json). The javascript is inline in index.html.

Mainly:
 * [Leaflet.geoJson](http://leafletjs.com/reference.html#geojson) is used. A tutorial that may help understand this is [here](http://leafletjs.com/examples/geojson.html). 
 * Styling is done in `styleStreets`, and is data dependent. For style option detail, see Leaflet's path [options](http://leafletjs.com/reference.html#path-options). 
 * Popups are defined in `bindPopup`. A simple underscore [template](http://underscorejs.org/#template) is used to create the text in the pop-up. Popup texts are also data (and data-structure) dependent. 
 * Loading the geojson file is done by the `$.getJSON` call. To change the geoJson layer rendered on the map, you can simply query another file, or make an ajax call. You can use the same `L.geoJson` call to render networks as well as data-structures remain the same. Note that for interactive rendering, you may want to keep track of the rendered geoJson layer that is added to the map, and make sure to clear it before rendering another set of data. 

To produce manhattan_mod.geo.json, I used these steps:

 * Go to [Metro Extracts](http://metro.teczno.com/) and download the New York PBF file.
 * Use [manhattan.poly](http://polygons.openstreetmap.fr/?id=2552485) and [osmconvert](http://wiki.openstreetmap.org/wiki/Osmconvert) to clip the file to just manhattan. I also dropped relations in the process:
      
      osmconvert -B=manhattan.poly --drop-relations --out-osm new-york.osm.pbf -o=manhattan.osm
 
 * Convert to geojson using [osmtogeojson](https://github.com/tyrasd/osmtogeojson/)
      
      osmtogeojson manhattan.osm > manhattan.geo.json

 * Run `data/mesa_mods.R`, taking care to point at the right files. I recommend running this line by line in R to get a picture of what is going on. This scripts reads the json file produced by osmtogeojson, drops all non-linestring features, drops all non-road features, and adds congestion_level and total_flow (using random sampling). You may need to modify file paths before running.

  
