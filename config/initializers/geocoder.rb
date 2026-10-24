Geocoder.configure(
  lookup: :nominatim,
  language: :ja,
  http_headers: {
  "User-Agent" => "WanNow/1.0 (contact: #{ENV.fetch('GEOCODER_CONTACT_EMAIL', 'not-configured')})"
  },
  timeout: 5,
  always_raise: [ Geocoder::OverQueryLimitError ]
)
