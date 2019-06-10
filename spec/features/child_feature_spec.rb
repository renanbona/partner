require "rails_helper"

describe Child, type: :feature, js: true do
  let(:partner) { create(:partner) }

  before do
    sign_in(partner)
    visit(root_path)
  end

  scenario "User can see a list of children" do
    stub_diaper_items_request
    family = create(:family, partner: partner)
    children = [
      create(:child, family: family),
      create(:child, family: family)
    ].reverse
    click_link "Children"
    children.each.with_index do |child, index|
      within "tbody" do
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(1)"))
          .to have_text(child.first_name)
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(2)"))
          .to have_text(child.last_name)
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(3)"))
          .to have_text(child.date_of_birth)
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(4)"))
          .to have_text(child.family.guardian_display_name)
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(5)"))
          .to have_text(child.comments)
      end
    end
  end

  describe "Create new child" do
    before { create(:family, partner: partner) }

    scenario "User can create a child from the family page" do
      stub_diaper_items_request
      click_link t("labels.families")
      click_link t("buttons.view_family")
      within("h5.card-header") do
        find_link(t("buttons.new_child")).click
      end
      expect(find("h1")).to have_text(t("labels.new_child"))
      fill_in("child_first_name", with: "Neil")
      fill_in("child_last_name", with: "Tyson")
      find("select#child_gender").click
      find("select#child_gender").find(:option, "Female").select_option
      fill_in("child_child_lives_with", with: "Parents")
      fill_in("child_health_insurance", with: "Blue Origin")
      find("select#child_item_needed_diaperid").click
      find("select#child_item_needed_diaperid")
        .find(:option, "Magic diaper").select_option
      fill_in("child_comments", with: "Comment 1")
      click_button t("buttons.create_child")
    end
  end
end
