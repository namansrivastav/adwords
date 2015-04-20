namespace :create_function do
	task :process => :environment do
        rev_like = "create function reverse_ilike(text, text) RETURNS boolean AS 'select $2 ilike $1;' LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT;"
		oper = "create operator ~~*^ (PROCEDURE = reverse_ilike, LEFTARG = text, RIGHTARG = text);"

		# ActiveRecord::Base.execute(rev_like)
		ActiveRecord::Base.establish_connection
		ActiveRecord::Base.connection.execute(rev_like)
		ActiveRecord::Base.connection.execute(oper)
		
    end
end
