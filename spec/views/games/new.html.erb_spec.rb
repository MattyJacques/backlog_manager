# frozen_string_literal: true

# frozen_string_literal => true

require 'rails_helper'

RSpec.describe 'games/new' do
  let(:igdb_results) { nil }

  before do
    assign(:igdb_results, igdb_results)
  end

  context 'when there are igdb results' do
    let(:igdb_results) do
      [
        {
          'id' => 7291,
          'cover' => {
            'id' => 404622,
            'image_id' => 'co8o7i'
          },
          'genres' => [
            {
              'id' => 5,
              'name' => 'Shooter'
            },
            {
              'id' => 13,
              'name' => 'Simulator'
            }
          ],
          'name' => 'Hunt: Showdown 1896',
          'platforms' => [
            {
              'id' => 6,
              'name' => 'PC (Microsoft Windows)'
            },
            {
              'id' => 48,
              'name' => 'PlayStation 4',
              'platform_family' => {
                'id' => 1,
                'name' => 'PlayStation'
              }
            },
            {
              'id' => 49,
              'name' => 'Xbox One',
              'platform_family' => {
                'id' => 2,
                'name' => 'Xbox'
              }
            },
            {
              'id' => 167,
              'name' => 'PlayStation 5',
              'platform_family' => {
                'id' => 1,
                'name' => 'PlayStation'
              }
            },
            {
              'id' => 169,
              'name' => 'Xbox Series X|S',
              'platform_family' => {
                'id' => 2,
                'name' => 'Xbox'
              }
            }
          ]
        },
        {
          'id' => 51050,
          'cover' => {
            'id' => 332507,
            'image_id' => 'co74kb'
          },
          'genres' => [
            {
              'id' => 14,
              'name' => 'Sport'
            }
          ],
          'name' => 'Bass Pro Shops: The Hunt - Trophy Showdown',
          'platforms' => [
            {
              'id' => 5,
              'name' => 'Wii',
              'platform_family' => {
                'id' => 5,
                'name' => 'Nintendo'
              }
            }
          ]
        }
      ]
    end

    it 'renders grid of game cards' do
      render

      assert_select 'img[src=?]', 'https://images.igdb.com/igdb/image/upload/t_cover_big/co8o7i.webp', count: 1
      assert_select 'div[data-nav-url-value=?]', '/games/7291', count: 1
      assert_select 'img[src=?]', 'https://images.igdb.com/igdb/image/upload/t_cover_big/co74kb.webp', count: 1
      assert_select 'div[data-nav-url-value=?]', '/games/51050', count: 1
    end
  end
end
