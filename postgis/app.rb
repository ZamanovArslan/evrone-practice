require 'pg'

class GeoAdapter
  SRID = 4326

  def self.to_wkt(lon, lat)
    "SRID=#{SRID};POINT(#{lon} #{lat})"
  end
end

pg = PG.connect(dbname: 'geo_test')
wkt = GeoAdapter.to_wkt(1,2)
result = pg.exec("SELECT *, ST_AsText(geom) FROM locations WHERE ST_DWithin(geom, '#{wkt}', 1)")

puts result.to_a

result = pg.exec("SELECT *, ST_AsText(geom) FROM locations WHERE geom && ST_MakeEnvelope(1, 2, 10, 5, 4326)")
puts result.to_a

