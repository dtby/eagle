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

ActiveRecord::Schema.define(version: 20150804091343) do

  create_table "alarm_auto", id: false, force: :cascade do |t|
    t.integer "SmsAutoFlag", limit: 4,  default: 0,  null: false
    t.string  "SendDate",    limit: 45, default: "", null: false
    t.string  "SendTime",    limit: 45, default: "", null: false
    t.string  "SendContent", limit: 45, default: "", null: false
    t.string  "SendUser",    limit: 45, default: "", null: false
    t.string  "SendTag",     limit: 45, default: "", null: false
  end

  create_table "alarm_event", id: false, force: :cascade do |t|
    t.integer "PointID",   limit: 4,  default: 0, null: false
    t.integer "Status",    limit: 4
    t.string  "AlarmTime", limit: 45
    t.string  "AckTime",   limit: 45
    t.integer "AckFlag",   limit: 4
    t.integer "SendFlag",  limit: 4
    t.string  "SendTime",  limit: 45
  end

  create_table "alarm_group", primary_key: "GroupID", force: :cascade do |t|
    t.string "GroupName", limit: 45, default: "", null: false
    t.string "UserGroup", limit: 45, default: "", null: false
  end

  create_table "alarm_point", primary_key: "PointID", force: :cascade do |t|
    t.integer "AlarmFlag",   limit: 4, default: 0, null: false
    t.integer "AlarmGroup",  limit: 4, default: 0, null: false
    t.integer "FilterCount", limit: 4, default: 0, null: false
    t.integer "FilterTime",  limit: 4, default: 0, null: false
    t.integer "ResendFlag",  limit: 4, default: 0, null: false
    t.integer "ResendTime",  limit: 4, default: 0, null: false
  end

  create_table "alarm_set", id: false, force: :cascade do |t|
    t.integer "SmsFlag",    limit: 4,  default: 1,      null: false
    t.string  "SmsType",    limit: 45, default: "GSM",  null: false
    t.string  "SmsCom",     limit: 45, default: "COM1", null: false
    t.string  "SmsBaud",    limit: 45, default: "9600", null: false
    t.string  "SmsNum",     limit: 45, default: "",     null: false
    t.integer "MailFlag",   limit: 4,  default: 0,      null: false
    t.string  "SmtpAddr",   limit: 45, default: "",     null: false
    t.string  "SmtpPort",   limit: 45, default: "",     null: false
    t.string  "MailAddr",   limit: 45, default: "",     null: false
    t.string  "MailUser",   limit: 45, default: "",     null: false
    t.string  "MailPass",   limit: 45, default: "",     null: false
    t.string  "MailValide", limit: 45, default: "",     null: false
  end

  create_table "alarm_user", primary_key: "GroupID", force: :cascade do |t|
    t.string  "GroupName",  limit: 45,  default: "", null: false
    t.string  "SmsNumber",  limit: 250
    t.string  "MailNumber", limit: 250
    t.integer "StartDay",   limit: 4,   default: 0,  null: false
    t.integer "EndDay",     limit: 4,   default: 0,  null: false
    t.integer "StartTime",  limit: 4,   default: 0,  null: false
    t.integer "EndTime",    limit: 4,   default: 0,  null: false
  end

  create_table "alm", id: false, force: :cascade do |t|
    t.string   "HostA",           limit: 16
    t.string   "HostB",           limit: 16
    t.integer  "PointID",         limit: 4,   default: 0
    t.integer  "AlarmType",       limit: 2,   default: 0
    t.boolean  "Status",                      default: false
    t.string   "AlarmValue",      limit: 32
    t.date     "ADate"
    t.time     "ATime"
    t.integer  "AMSecond",        limit: 2,   default: 0
    t.boolean  "AckFlag",                     default: false
    t.string   "User",            limit: 32
    t.string   "Note",            limit: 255
    t.datetime "ConfirmDateTime"
  end

  create_table "analog_data", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "analog_points", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cos", id: false, force: :cascade do |t|
    t.string   "HostA",           limit: 16
    t.string   "HostB",           limit: 16
    t.integer  "PointID",         limit: 4,   default: 0
    t.integer  "Status",          limit: 2,   default: 0
    t.date     "ADate"
    t.time     "ATime"
    t.integer  "AMSecond",        limit: 2,   default: 0
    t.boolean  "AckFlag",                     default: false
    t.string   "User",            limit: 32
    t.string   "Note",            limit: 255
    t.datetime "ConfirmDateTime"
  end

  create_table "digital_points", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fdata", id: false, force: :cascade do |t|
    t.string  "HostA",      limit: 16
    t.string  "HostB",      limit: 16
    t.integer "IedID",      limit: 4,  default: 0
    t.string  "IedFID",     limit: 64
    t.string  "IedVersion", limit: 64
    t.date    "FDate"
    t.time    "FTime"
    t.integer "FMSecond",   limit: 2,  default: 0
    t.string  "FType",      limit: 32
    t.float   "FLocation",  limit: 24, default: 0.0
    t.float   "FCurrent",   limit: 24, default: 0.0
    t.float   "FFreq",      limit: 24, default: 0.0
    t.integer "FReTimes",   limit: 2,  default: 0
    t.integer "FSGroup",    limit: 2,  default: 0
    t.string  "FileName",   limit: 32
  end

  create_table "hdata20150420", id: false, force: :cascade do |t|
    t.string  "HostA",   limit: 16
    t.string  "HostB",   limit: 16
    t.integer "PointID", limit: 4,  default: 0
    t.float   "fValue",  limit: 24, default: 0.0
    t.date    "ADate"
    t.time    "ATime"
  end

  create_table "hdata20150428", id: false, force: :cascade do |t|
    t.string  "HostA",   limit: 16
    t.string  "HostB",   limit: 16
    t.integer "PointID", limit: 4,  default: 0
    t.float   "fValue",  limit: 24, default: 0.0
    t.date    "ADate"
    t.time    "ATime"
  end

  create_table "hdata20150429", id: false, force: :cascade do |t|
    t.string  "HostA",   limit: 16
    t.string  "HostB",   limit: 16
    t.integer "PointID", limit: 4,  default: 0
    t.float   "fValue",  limit: 24, default: 0.0
    t.date    "ADate"
    t.time    "ATime"
  end

  create_table "point_states", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ptai", primary_key: "PointID", force: :cascade do |t|
    t.string  "StationName",      limit: 64
    t.string  "BayName",          limit: 64
    t.string  "GroupName",        limit: 64
    t.string  "PointName",        limit: 64
    t.integer "LowPointID",       limit: 4,   default: 0
    t.integer "RaisePointID",     limit: 4,   default: 0
    t.string  "RSName",           limit: 64
    t.string  "Comment",          limit: 255
    t.integer "ValueType",        limit: 2,   default: 0
    t.string  "InitialValue",     limit: 32
    t.boolean "RecFlag",                      default: false
    t.integer "LogDB",            limit: 2,   default: 0
    t.float   "LogDBPar",         limit: 24,  default: 1.0
    t.boolean "AlarmLimitFlag",               default: false
    t.boolean "AlarmRatioFlag",               default: false
    t.integer "AlarmHoldingTime", limit: 2,   default: 0
    t.string  "UUpValue",         limit: 32
    t.string  "UpValue",          limit: 32
    t.string  "DnValue",          limit: 32
    t.string  "DDnValue",         limit: 32
    t.string  "UUpName",          limit: 64
    t.string  "UpName",           limit: 64
    t.string  "DnName",           limit: 64
    t.string  "DDnName",          limit: 64
    t.float   "Ratio",            limit: 24,  default: 0.0
    t.string  "RatioName",        limit: 64
    t.string  "MinValue",         limit: 32
    t.string  "MaxValue",         limit: 32
    t.boolean "CCFlag",                       default: false
    t.boolean "PMSFlag",                      default: false
    t.boolean "RealFlag",                     default: false
  end

  create_table "ptao", primary_key: "PointID", force: :cascade do |t|
    t.string  "StationName",      limit: 64
    t.string  "BayName",          limit: 64
    t.string  "GroupName",        limit: 64
    t.string  "PointName",        limit: 64
    t.integer "ValueType",        limit: 2,   default: 0
    t.string  "InitialValue",     limit: 32
    t.string  "RSName",           limit: 64
    t.string  "Comment",          limit: 255
    t.boolean "RecFlag",                      default: false
    t.integer "LogDB",            limit: 2,   default: 0
    t.float   "LogDBPar",         limit: 24,  default: 1.0
    t.string  "MinValue",         limit: 32
    t.string  "MaxValue",         limit: 32
    t.integer "ControlType",      limit: 4,   default: 0
    t.integer "SBOTimeOut",       limit: 4,   default: 1000
    t.boolean "CCFlag",                       default: false
    t.boolean "PMSFlag",                      default: false
    t.boolean "RealFlag",                     default: false
    t.boolean "SettingAlarmFlag",             default: false
    t.string  "DIForChange",      limit: 32
    t.string  "AIForConfirm",     limit: 32
    t.string  "AssociateAI",      limit: 64
    t.boolean "LockStatus",                   default: false
  end

  create_table "ptci", primary_key: "PointID", force: :cascade do |t|
    t.string  "StationName",  limit: 64
    t.string  "BayName",      limit: 64
    t.string  "GroupName",    limit: 64
    t.string  "PointName",    limit: 64
    t.integer "ValueType",    limit: 2,   default: 0
    t.string  "InitialValue", limit: 32
    t.string  "RSName",       limit: 64
    t.string  "Comment",      limit: 255
    t.boolean "RecFlag",                  default: false
    t.integer "LogDB",        limit: 2,   default: 0
    t.float   "LogDBPar",     limit: 24,  default: 1.0
    t.string  "MinValue",     limit: 32
    t.string  "MaxValue",     limit: 32
    t.boolean "RealFlag",                 default: false
    t.boolean "CCFlag",                   default: false
    t.boolean "PMSFlag",                  default: false
  end

  create_table "ptdi", primary_key: "PointID", force: :cascade do |t|
    t.string  "StationName",  limit: 64
    t.string  "BayName",      limit: 64
    t.string  "GroupName",    limit: 64
    t.string  "PointName",    limit: 64
    t.integer "ValueType",    limit: 2,   default: 0
    t.string  "InitialValue", limit: 32
    t.string  "TripPointID",  limit: 32
    t.string  "ClosePointID", limit: 32
    t.integer "COS",          limit: 2,   default: 0
    t.string  "RSName",       limit: 64
    t.string  "Comment",      limit: 255
    t.boolean "InvertStatus",             default: false
    t.boolean "AutoFlag",                 default: false
    t.boolean "DoubleFlag",               default: false
    t.string  "Class",        limit: 32
    t.string  "TravelName",   limit: 16
    t.string  "OffName",      limit: 16
    t.string  "OnName",       limit: 16
    t.string  "InvalidName",  limit: 16
    t.boolean "CCFlag",                   default: false
    t.boolean "PMSFlag",                  default: false
    t.boolean "RealFlag",                 default: false
  end

  create_table "ptdo", primary_key: "PointID", force: :cascade do |t|
    t.string  "StationName",     limit: 64
    t.string  "BayName",         limit: 64
    t.string  "GroupName",       limit: 64
    t.string  "PointName",       limit: 64
    t.integer "ValueType",       limit: 2,   default: 0
    t.string  "InitialValue",    limit: 32
    t.string  "RSName",          limit: 64
    t.string  "Comment",         limit: 255
    t.integer "CommandType",     limit: 2,   default: 0
    t.string  "AssociateDI",     limit: 64
    t.boolean "OpenLockStatus",              default: false
    t.boolean "CloseLockStatus",             default: false
    t.integer "ControlType",     limit: 4,   default: 0
    t.integer "SBOTimeOut",      limit: 4,   default: 10000
  end

  create_table "ptevt", primary_key: "PointID", force: :cascade do |t|
    t.string  "StationName",  limit: 64
    t.string  "BayName",      limit: 64
    t.string  "GroupName",    limit: 64
    t.string  "PointName",    limit: 64
    t.integer "ValueType",    limit: 2,   default: 0
    t.string  "InitialValue", limit: 32
    t.integer "COS",          limit: 2,   default: 0
    t.string  "RSName",       limit: 64
    t.string  "Comment",      limit: 255
    t.boolean "InvertStatus",             default: false
    t.boolean "AutoFlag",                 default: false
    t.boolean "DoubleFlag",               default: false
    t.string  "Class",        limit: 32
    t.string  "TravelName",   limit: 16
    t.string  "OffName",      limit: 16
    t.string  "OnName",       limit: 16
    t.string  "InvalidName",  limit: 16
    t.boolean "CCFlag",                   default: false
    t.boolean "PMSFlag",                  default: false
    t.boolean "RealFlag",                 default: false
  end

  create_table "ptied", primary_key: "IedID", force: :cascade do |t|
    t.string "StationName", limit: 64
    t.string "BayName",     limit: 64
    t.string "GroupName",   limit: 64
    t.string "IedVender",   limit: 32
    t.string "IedModel",    limit: 32
    t.string "IedFID",      limit: 32
    t.string "IedVersion",  limit: 32
    t.string "RSName",      limit: 64
    t.string "Address",     limit: 32
    t.date   "ADate"
    t.time   "ATime"
  end

  create_table "ptpsd", primary_key: "PointID", force: :cascade do |t|
    t.string  "StationName",  limit: 64
    t.string  "BayName",      limit: 64
    t.string  "GroupName",    limit: 64
    t.string  "PointName",    limit: 64
    t.string  "RSName",       limit: 64
    t.string  "Comment",      limit: 255
    t.integer "PointType",    limit: 2,   default: 0
    t.integer "ValueType",    limit: 2,   default: 0
    t.string  "InitialValue", limit: 32
    t.boolean "PointOwner",               default: false
    t.string  "OffName",      limit: 32
    t.string  "OnName",       limit: 32
    t.boolean "RecFlag",                  default: false
    t.integer "LogDB",        limit: 2,   default: 0
    t.float   "LogDBPar",     limit: 24,  default: 1.0
    t.boolean "AutoFlag",                 default: false
    t.boolean "CCFlag",                   default: false
    t.boolean "PMSFlag",                  default: false
    t.boolean "DoubleFlag",               default: false
    t.boolean "RealFlag",                 default: false
  end

  create_table "ptsts", id: false, force: :cascade do |t|
    t.integer "PointID",   limit: 4,  default: 0,     null: false
    t.integer "ValueType", limit: 2,  default: 0,     null: false
    t.string  "Status",    limit: 64
    t.string  "Confirm",   limit: 64
    t.boolean "Flag",                 default: false
    t.date    "ADate"
    t.time    "ATime"
  end

  create_table "sdata", id: false, force: :cascade do |t|
    t.string  "HostA",   limit: 16
    t.string  "HostB",   limit: 16
    t.integer "IedID",   limit: 4,   default: 0, null: false
    t.integer "SGroup",  limit: 1,   default: 0, null: false
    t.integer "SNo",     limit: 2,   default: 0, null: false
    t.string  "Comment", limit: 255
    t.string  "SData",   limit: 64
  end

  create_table "soe", id: false, force: :cascade do |t|
    t.string   "HostA",           limit: 16
    t.string   "HostB",           limit: 16
    t.integer  "PointID",         limit: 4,   default: 0
    t.integer  "Status",          limit: 2,   default: 0
    t.date     "ADate"
    t.time     "ATime"
    t.integer  "AMSecond",        limit: 2,   default: 0
    t.boolean  "AckFlag",                     default: false
    t.string   "User",            limit: 32
    t.string   "Note",            limit: 255
    t.datetime "ConfirmDateTime"
  end

  create_table "sys", id: false, force: :cascade do |t|
    t.string  "HostA",        limit: 16
    t.string  "HostB",        limit: 16
    t.string  "Type",         limit: 64
    t.string  "WarningLevel", limit: 64
    t.string  "Content",      limit: 255
    t.date    "ADate"
    t.time    "ATime"
    t.integer "AMSecond",     limit: 2,   default: 0
  end

  create_table "ugp", id: false, force: :cascade do |t|
    t.integer "GID",        limit: 2,   default: 0, null: false
    t.string  "GName",      limit: 32
    t.string  "GComment",   limit: 128
    t.integer "GVPriority", limit: 4,   default: 0
    t.integer "GCPriority", limit: 4,   default: 0
    t.integer "GMPriority", limit: 4,   default: 0
    t.integer "UID",        limit: 2,   default: 0, null: false
  end

  create_table "user", primary_key: "UID", force: :cascade do |t|
    t.string  "UName",        limit: 32
    t.string  "Password",     limit: 128
    t.boolean "PriorityFlag",             default: false
    t.integer "VPriority",    limit: 4,   default: 0
    t.integer "CPriority",    limit: 4,   default: 0
    t.integer "MPriority",    limit: 4,   default: 0
    t.string  "Mail",         limit: 64
    t.string  "SMS",          limit: 64
    t.string  "Phone",        limit: 32
    t.string  "Mobile",       limit: 32
    t.string  "Comment",      limit: 128
  end

  create_table "usr", primary_key: "UID", force: :cascade do |t|
    t.string  "UName",        limit: 32
    t.string  "Password",     limit: 128
    t.boolean "PriorityFlag",             default: false
    t.integer "VPriority",    limit: 4,   default: 0
    t.integer "CPriority",    limit: 4,   default: 0
    t.integer "MPriority",    limit: 4,   default: 0
    t.string  "Mail",         limit: 64
    t.string  "SMS",          limit: 64
    t.string  "Phone",        limit: 32
    t.string  "Mobile",       limit: 32
    t.string  "Comment",      limit: 128
  end

end
