module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def add_attach_file(question)
    visit question_path(question)
    click_on 'Edit'
    attach_file('question[files][]', File.join(Rails.root, '/spec/rails_helper.rb'))
    click_on 'Save'
    wait_for_ajax
  end
end
