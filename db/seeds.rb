# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Platform.create!([{ igdb_id: 9, ps_abbreviation: 'PS3' },
                  { igdb_id: 46, ps_abbreviation: 'PSVITA' },
                  { igdb_id: 48, ps_abbreviation: 'PS4' },
                  { igdb_id: 167, ps_abbreviation: 'PS5' }])
User.create!([{ username: 'LetsDeleteThis01', email: 'iftw+letsdeletethis01@live.co.uk', password: 'letsdeletethis01' },
              { username: 'NeonFishy', email: 'iftw+neonfishy@live.co.uk', password: 'neonfishy' },
              { username: 'exoticCentipede', email: 'iftw+exoticcentipede@live.co.uk', password: 'exoticcentipede' },
              { username: 'Toxic-Prosperity', email: 'iftw+toxic-prosperity@live.co.uk', password: 'toxic-prosperity' },
              { username: 'ToxicProsperity', email: 'iftw+toxicprosperity@live.co.uk', password: 'toxicprosperity' },
              { username: 'ToxicProsperity-', email: 'iftw+toxicprosperity-@live.co.uk', password: 'toxicprosperity-' }])
PSNAccount.create!([{ user: User.find_by!(username: 'LetsDeleteThis01'), psn_id: 'LetsDeleteThis01' }])
