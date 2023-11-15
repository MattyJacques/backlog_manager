# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
PlatformFamily.create!([{ name: 'PlayStation', igdb_id: 1 },
                        { name: 'Xbox', igdb_id: 2 },
                        { name: 'Nintendo', igdb_id: 5 }])
Platform.create!([{ name: 'PlayStation 3', abbreviation: 'PS3', igdb_id: 9, platform_family_id: 1 },
                  { name: 'Playstation Vita', abbreviation: 'PSVITA', platform_family_id: 1 },
                  { name: 'PlayStation 4', abbreviation: 'PS4', igdb_id: 48, platform_family_id: 1 },
                  { name: 'PlayStation 5', abbreviation: 'PS5', igdb_id: 167, platform_family_id: 1 },
                  { name: 'PC (Microsoft Windows)', igdb_id: 6 },
                  { name: 'Xbox One', igdb_id: 49, platform_family_id: 2 },
                  { name: 'Xbox Series X|S', igdb_id: 169, platform_family_id: 2 },
                  { name: 'Google Stadia', igdb_id: 170 },
                  { name: 'Nintendo Switch', igdb_id: 130, platform_family_id: 3 }])
User.create!([{ username: 'LetsDeleteThis01', email: 'iftw+letsdeletethis01@live.co.uk', password: 'letsdeletethis01' },
              { username: 'NeonFishy', email: 'iftw+neonfishy@live.co.uk', password: 'neonfishy' },
              { username: 'exoticCentipede', email: 'iftw+exoticcentipede@live.co.uk', password: 'exoticcentipede' },
              { username: 'Toxic-Prosperity', email: 'iftw+toxic-prosperity@live.co.uk', password: 'toxic-prosperity' },
              { username: 'ToxicProsperity', email: 'iftw+toxicprosperity@live.co.uk', password: 'toxicprosperity' },
              { username: 'ToxicProsperity-', email: 'iftw+toxicprosperity-@live.co.uk', password: 'toxicprosperity-' }])
PSNAccount.create!([{ user: User.find_by!(username: 'LetsDeleteThis01'), psn_id: 'LetsDeleteThis01' }])
