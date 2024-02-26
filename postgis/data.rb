require 'pg'

class GeoAdapter
  SRID = 4326

  def self.to_wkt(lon, lat)
    "SRID=#{SRID};POINT(#{lon} #{lat})"
  end
end

pg = PG.connect(dbname: 'geo_test')


def version_1(pg)
  wkt = GeoAdapter.to_wkt(1,2)

  pg.exec("INSERT INTO locations (geom) VALUES ('#{wkt}')")
end

def version_2(pg)
  [[1,2], [1,5], [10,2], [10,5]].each do |lon, lat|
    wkt = GeoAdapter.to_wkt(lon, lat)
    pg.exec("INSERT INTO locations (geom) VALUES ('#{wkt}')")
  end
end

def version_3(pg)
  wkt = GeoAdapter.to_wkt(5, 3)
  pg.exec("INSERT INTO locations (geom) VALUES ('#{wkt}')")
end

def version_4(pg)
  wkt = GeoAdapter.to_wkt(20, 20)
  pg.exec("INSERT INTO locations (geom) VALUES ('#{wkt}')")
end

version_4(pg)