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

  create_table :commits, force: true do |t|
    t.references :parent_commit, foreign_key: { to_table: :commits }
  end

  create_table :trees, force: true do |t|
    t.belongs_to :commit
    t.belongs_to :furcate_team
  end
end
