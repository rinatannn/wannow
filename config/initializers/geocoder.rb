Geocoder.configure(
  lookup: :google,
  api_key: ENV["GOOGLE_GEOCODING_API_KEY"],
  language: :ja,
  timeout: 5,
  always_raise: [ Geocoder::OverQueryLimitError ]
)
