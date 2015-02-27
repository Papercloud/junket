# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_150_227_023_152) do

  create_table 'junket_action_templates', force: true do |t|
    t.string 'name'
    t.string 'campaign_name'
    t.string 'email_subject'
    t.text 'email_body'
    t.text 'sms_body'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string 'type'
    t.integer 'sequence_template_id'
    t.integer 'run_after_duration',   default: 0, null: false
    t.integer 'position',             default: 0, null: false
  end

  add_index 'junket_action_templates', ['sequence_template_id'], name: 'index_junket_action_templates_on_sequence_template_id'

  create_table 'junket_actions', force: true do |t|
    t.integer 'action_template_id', null: false
    t.integer 'object_id',          null: false
    t.string 'object_type',        null: false
    t.string 'state',              null: false
    t.datetime 'run_datetime',       null: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'junket_actions', ['action_template_id'], name: 'index_junket_actions_on_action_template_id'
  add_index 'junket_actions', %w(object_id object_type), name: 'index_junket_actions_on_object_id_and_object_type'

  create_table 'junket_filter_conditions', force: true do |t|
    t.integer 'filter_id'
    t.integer 'campaign_id'
    t.string 'value'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'junket_filter_conditions', ['campaign_id'], name: 'index_junket_filter_conditions_on_campaign_id'
  add_index 'junket_filter_conditions', ['filter_id'], name: 'index_junket_filter_conditions_on_filter_id'

  create_table 'junket_filters', force: true do |t|
    t.string 'name'
    t.string 'term'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string 'value_type'
  end

  create_table 'junket_recipients', force: true do |t|
    t.integer 'target_id'
    t.string 'target_type'
    t.integer 'action_id'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string 'email_third_party_id'
  end

  add_index 'junket_recipients', ['action_id'], name: 'index_junket_recipients_on_action_id'
  add_index 'junket_recipients', ['email_third_party_id'], name: 'index_junket_recipients_on_email_third_party_id'
  add_index 'junket_recipients', %w(target_id target_type), name: 'index_junket_recipients_on_target_id_and_target_type'

  create_table 'junket_sequence_templates', force: true do |t|
    t.string 'name',                             null: false
    t.integer 'owner_id'
    t.string 'owner_type'
    t.string 'access_level', default: 'private', null: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'junket_sequence_templates', %w(owner_id owner_type), name: 'index_junket_sequence_templates_on_owner_id_and_owner_type'

  create_table 'users', force: true do |t|
    t.string 'email'
    t.string 'mobile'
    t.string 'first_name'
    t.string 'last_name'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

end
