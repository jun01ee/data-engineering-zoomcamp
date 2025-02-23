models:
  taxi_rides_ny:
      # Applies to all files under models/.../
      staging:
          materialized: view
      core:
          materialized: table
vars:
  payment_type_values: [1, 2, 3, 4, 5, 6]

seeds: 
    taxi_rides_ny:
        taxi_zone_lookup:
            +column_types:
                locationid: numeric