namespace :admin do
  desc 'Create a new admin.'
  task new: :environment do
    @user = User.new
    STDOUT.puts "Enter first name."
    @user.first_name = STDIN.gets.chomp
    STDOUT.puts "Enter last name."
    @user.last_name = STDIN.gets.chomp
    STDOUT.puts "Enter email Id."
    @user.email = STDIN.gets.chomp
    STDOUT.puts "Enter password."
    @user.password = STDIN.gets.chomp
    STDOUT.puts "Re-enter password."
    @user.password_confirmation = STDIN.gets.chomp
    @user.admin = true
    @user.save!
  end
end
