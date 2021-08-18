# frozen_string_literal: true

ActiveRecord::Schema.define do
  # Set up any tables you need to exist for your test suite that don't belong
  # in migrations.
  create_table :furcate_people, force: true do |t|
    t.string :furcate_id
    t.string :color
  end

  create_table :furcate_teams, force: true do |t|
    t.string :furcate_id
    t.string :color
  end
end
