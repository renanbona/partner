module StubsHelper
  def stub_diaper_items_request
    stub_request(
      :any,
      "#{ENV["DIAPERBANK_ENDPOINT"]}/partner_requests/#{partner.id}"
    ).to_return(body: [{ id: 1, name: "Magic diaper" }].to_json, status: 200)
  end
end
