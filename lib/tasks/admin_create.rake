namespace :admin do
  desc 'Create a new admin.'
  task new: :environment do
    def get_input
      STDIN.gets.chomp
    end
    @user = User.new
    STDOUT.puts "Enter first name."
    @user.first_name = get_input
    STDOUT.puts "Enter last name."
    @user.last_name = get_input
    STDOUT.puts "Enter email Id."
    @user.email = get_input
    STDOUT.puts "Enter password."
    @user.password = get_input
    STDOUT.puts "Re-enter password."
    @user.password_confirmation = get_input
    @user.admin = true
    @user.verified_at = Time.current
    @user.save
    @user.errors.full_messages.each do |msg|
      STDOUT.puts msg
    end
  end
end
