class EmailCombination

  def initialize(user)
    @user_params = user
    @level = 1
    Apilayer::Mailbox.configure do |configs|
      configs.access_key = Rails.application.credentials.mail[:access_key]
      configs.https = true
    end
  end

  def generate_email
    case @level
      when 1
        email = "#{@user_params[:first_name]}" "." "#{@user_params[:last_name]}" "@" "#{@user_params[:url]}"
      when 2
        email = "#{@user_params[:first_name]}" "@" "#{@user_params[:url]}"
      when 3
        email = "#{@user_params[:first_name]}""#{@user_params[:last_name]}" "@" "#{@user_params[:url]}"
      when 4
        email = "#{@user_params[:last_name]}" "." "#{@user_params[:first_name]}" "@" "#{@user_params[:url]}"
      when 5
        email = "#{@user_params[:first_name][0]}" "." "#{@user_params[:last_name]}" "@" "#{@user_params[:url]}"
      when 6
        email = "#{@user_params[:first_name][0]}""#{@user_params[:last_name][0]}" "@" "#{@user_params[:url]}"
      else
        email = "No valid email found"
        return;
      end
      @level += 1
      check_valid(email)
  end

  def check_valid email
    result = Apilayer::Mailbox.check(email)
    if result['format_valid'] == true && result['mx_found'] == true && result['smtp_check'] == true &&  result['catch_all'] == nil
      user = User.last
      user.update_attribute(:email, email)
    else
      generate_email
    end
  end
end
