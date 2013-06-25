create temp table colors(name char(7), color char(6));
insert into colors values ('Metro A', '007f00');
insert into colors values ('Metro B', '827f00');
insert into colors values ('Metro C', '7f0000');

select point.name,
        ST_Transform(
            ST_Centroid(
                ST_Union(point.way)
            ),
            4326
        ),
        'rail-underground' as "marker-symbol",
        colors.color as "marker-color"
    from planet_osm_point as point
    INNER JOIN 
        colors ON point.name ilike '%'||colors.name,
     planet_osm_polygon as polygon 
        --substring(point.name, 1,2) = colors.name
    where polygon.name = 'Praha' AND 
        polygon.admin_level='8' AND 
        point.railway = 'subway_entrance' AND 
        (st_within(point.way, polygon.way)) AND 
        point.name is not null
    GROUP BY
        point.name, colors.color
