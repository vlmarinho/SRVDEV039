
CREATE FUNCTION [dbo].[splitString] (@CharToFind char(1), @StringWhereFind VARCHAR(1024))  
Returns @return_table table (Campo varchar(255))
as
begin
	declare @temp_table table (Campo Varchar(255))
	declare @token varchar (10),
		@remaining_list varchar (1000),
		@pos int,
		@i int,
		@remaining_len int

	--set @i = 1
	set @remaining_list = @StringWhereFind
	set @pos = 0
	set @remaining_len = len(@remaining_list)

	set @pos = charindex ( @CharToFind, @remaining_list )

	while ((@remaining_len > 0) AND (@pos > 0))
	begin
		set @token = substring(@remaining_list, 1, @pos -1 )
		set @remaining_list = substring(@remaining_list,@pos + 1, @remaining_len)
		set @remaining_len = len(@remaining_list)
		insert into @temp_table ( Campo )
		values (convert(varchar(255), @token ))
		set @pos = charindex ( @CharToFind, @remaining_list )
		--set @i = @i + 1
end /* end of while */

if len ( @remaining_list ) > 0
begin
	insert into @temp_table ( Campo )
	values (convert(varchar(255), @remaining_list))
end

insert @return_table select * from @temp_table 
--return @return_table
return 

end
