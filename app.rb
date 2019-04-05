require 'piwik'
require 'influxdb'

%w[PIWIK_URL PIWIK_TOKEN PIWIK_SITE_IDS
   INFLUX_DB_NAME INFLUX_USER_NAME INFLUX_PASSWORD INFLUX_HOST INFLUX_PORT
   APP_ENV].each do |var|
  raise "must provide env var #{var}!" if ENV[var].to_s == ''
end

Piwik::PIWIK_URL = ENV['PIWIK_URL']
Piwik::PIWIK_TOKEN = ENV['PIWIK_TOKEN']

site_stats = ENV['PIWIK_SITE_IDS'].split(',').map(&:to_i).map do |site_id|
  site = Piwik::Site.load(site_id)

  summary = site.actions.summary

  {
    site_id: site_id,
    pageviews: summary.nb_pageviews,
    uniq_pageviews: summary.nb_uniq_pageviews,
    searches: summary.nb_searches
  }
end

influxdb = InfluxDB::Client.new ENV['INFLUX_DB_NAME'],
                                username: ENV['INFLUX_USER_NAME'],
                                password: ENV['INFLUX_PASSWORD'],
                                async: false,
                                hosts: [ENV['INFLUX_HOST']],
                                port: ENV['INFLUX_PORT'],
                                use_ssl: true

site_stats.each do |stats|
  site_id = stats[:site_id]
  stats.delete(:site_id)

  influxdb.write_point(site_id.to_s, values: stats, tags: { env: ENV['APP_ENV'] })
end
