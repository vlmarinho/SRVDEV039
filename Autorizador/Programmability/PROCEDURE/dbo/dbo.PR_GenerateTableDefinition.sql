CREATE PROCEDURE dbo.PR_GenerateTableDefinition (@tableNameInput VARCHAR(255), @returnCode INT OUTPUT, @returnMessage VARCHAR(MAX) OUTPUT)  
AS  
BEGIN  
 SET NOCOUNT ON  
   
 SET @returnCode = 0;  
 SET @returnMessage = 'OK';  
  
 BEGIN TRY  
   
  DECLARE @tableName VARCHAR(200)  
   ,@SCHEMANAME VARCHAR(255)  
   ,@STRINGLEN INT  
   ,@TABLE_ID INT  
   ,@FINALSQL VARCHAR(max)  
   ,@CONSTRAINTSQLS VARCHAR(max)  
   ,@CHECKCONSTSQLS VARCHAR(max)  
   ,@FKSQLS VARCHAR(max)  
   ,@INDEXSQLS VARCHAR(max)  
   ,@vbCrLf CHAR(2)  
   ,@vbTab CHAR(1)  
   
  SET @vbCrLf = CHAR(13) + CHAR(10)  
  SET @vbTab = CHAR(9)  
   
  SELECT @SCHEMANAME = Isnull(Parsename(@tableNameInput, 2), 'dbo')  
   ,@tableName = Parsename(@tableNameInput, 1)  
     
  SELECT @TABLE_ID = [object_id]  
  FROM sys.objects  
  WHERE [type] = 'U'  
   AND [name] <> 'dtproperties'  
   AND [name] = @tableName  
   AND [schema_id] = Schema_id(@SCHEMANAME);  
   
  IF Isnull(@TABLE_ID, 0) = 0  
  BEGIN  
   SET @returnCode = 1;  
   SET @returnMessage = CONCAT('Table object [', @SCHEMANAME, '].[', @tableName, '] does not exist in Database [', Db_name() , ']');  
  END  
   
  SELECT @FINALSQL = 'CREATE TABLE [' + @SCHEMANAME + '].[' + @tableName + '] ( ' + @vbCrLf + @vbTab  
   
  SELECT @TABLE_ID = Object_id(@tableName)  
   
  SELECT @STRINGLEN = Max(Len(sys.columns.[name])) + 1  
  FROM sys.objects  
  INNER JOIN sys.columns ON sys.objects.[object_id] = sys.columns.[object_id]  
   AND sys.objects.[object_id] = @TABLE_ID;  
   
  SELECT @FINALSQL = @FINALSQL + CASE   
    WHEN sys.columns.[is_computed] = 1  
     THEN '[' + sys.columns.[name] + '] ' + 'AS ' + Isnull(CALC.DEFINITION, '')  
    ELSE '[' + sys.columns.[name] + '] ' + Upper(Type_name(sys.columns.[user_type_id])) + CASE   
      WHEN Type_name(sys.columns.[user_type_id]) IN (  
        'decimal'  
        ,'numeric'  
        )  
       THEN '(' + CONVERT(VARCHAR, sys.columns.[precision]) + ',' + CONVERT(VARCHAR, sys.  
         columns.[scale]) + ')' + CASE   
         WHEN Columnproperty(@TABLE_ID, sys.columns.[name], 'IsIdentity') = 0  
          THEN ''  
         ELSE ' IDENTITY(' + CONVERT(VARCHAR, Isnull(Ident_seed(@tableName), 1)) +   
          ',' + CONVERT(VARCHAR, Isnull(Ident_incr(@tableName), 1)) + ')'  
         END + CASE   
         WHEN sys.columns.[is_nullable] = 0  
          THEN ' NOT NULL'  
         ELSE ' NULL'  
         END  
      WHEN Type_name(sys.columns.[user_type_id]) IN (  
        'float'  
        ,'real'  
        )  
       THEN CASE   
         WHEN sys.columns.[precision] = 53  
          THEN CASE   
            WHEN sys.columns.[is_nullable] = 0  
             THEN ' NOT NULL'  
            ELSE ' NULL'  
            END  
         ELSE '(' + CONVERT(VARCHAR, sys.columns.[precision]) + ')' + CASE   
           WHEN sys.columns.[is_nullable] = 0  
            THEN ' NOT NULL'  
           ELSE ' NULL'  
           END  
         END  
      WHEN Type_name(sys.columns.[user_type_id]) IN (  
        'char'  
        ,'varchar'  
        )  
       THEN CASE   
         WHEN sys.columns.[max_length] = - 1  
          THEN '(max)' + CASE   
            WHEN sys.columns.collation_name IS NULL  
             THEN ''  
            ELSE ' COLLATE ' + sys.columns.collation_name  
            END + CASE   
            WHEN sys.columns.[is_nullable] = 0  
             THEN ' NOT NULL'  
            ELSE '     NULL'  
            END  
         ELSE '(' + CONVERT(VARCHAR, sys.columns.[max_length]) + ')' + CASE   
           WHEN sys.columns.collation_name IS NULL  
            THEN ''  
           ELSE ' COLLATE ' + sys.columns.collation_name  
           END + CASE   
           WHEN sys.columns.[is_nullable] = 0  
            THEN ' NOT NULL'  
           ELSE ' NULL'  
           END  
         END  
      WHEN Type_name(sys.columns.[user_type_id]) IN (  
        'nchar'  
        ,'nvarchar'  
        )  
       THEN CASE   
         WHEN sys.columns.[max_length] = - 1  
          THEN '(max)' + CASE   
            WHEN sys.columns.collation_name IS NULL  
             THEN ''              ELSE ' COLLATE ' + sys.columns.collation_name  
            END + CASE   
            WHEN sys.columns.[is_nullable] = 0  
             THEN ' NOT NULL'  
            ELSE ' NULL'  
            END  
         ELSE '(' + CONVERT(VARCHAR, (sys.columns.[max_length]  
            )) + ')' + CASE   
           WHEN sys.columns.collation_name IS NOT NULL  
            THEN ''  
           ELSE ' COLLATE ' + sys.columns.collation_name  
           END + CASE   
           WHEN sys.columns.[is_nullable] = 0  
            THEN ' NOT NULL'  
           ELSE ' NULL'  
           END  
         END  
      WHEN Type_name(sys.columns.[user_type_id]) IN (  
        'datetime'  
        ,'money'  
        ,'text'  
        ,'image'  
        )  
       THEN CASE   
         WHEN sys.columns.[is_nullable] = 0  
          THEN ' NOT NULL'  
         ELSE ' NULL'  
         END  
      ELSE CASE   
        WHEN Columnproperty(@TABLE_ID, sys.columns.[name], 'IsIdentity') = 0  
         THEN ''  
        ELSE ' IDENTITY(' + CONVERT(VARCHAR, Isnull(Ident_seed(@tableName), 1)) + ',' +   
         CONVERT(VARCHAR, Isnull(Ident_incr(@tableName), 1)) + ')'  
        END + CASE   
        WHEN sys.columns.[is_nullable] = 0  
         THEN ' NOT NULL'  
        ELSE ' NULL'  
        END  
      END + CASE   
      WHEN sys.columns.[default_object_id] = 0  
       THEN ''  
      ELSE ' CONSTRAINT [' + def.NAME + '] DEFAULT ' + Isnull(def.[definition], '')  
      END --CASE cdefault         
    END --iscomputed           
   + @vbCrLf + @vbTab + ','  
  FROM sys.columns  
  LEFT OUTER JOIN sys.default_constraints DEF ON sys.columns.[default_object_id] = DEF.[object_id]  
  LEFT OUTER JOIN sys.computed_columns CALC ON sys.columns.[object_id] = CALC.[object_id]  
   AND sys.columns.[column_id] = CALC.[column_id]  
  WHERE sys.columns.[object_id] = @TABLE_ID  
  ORDER BY sys.columns.[column_id]  
   
  SELECT @STRINGLEN = Max(Len([name])) + 1  
  FROM sys.objects  
   
  DECLARE @Results TABLE (  
   [schema_id] INT  
   ,[schema_name] VARCHAR(255)  
   ,[object_id] INT  
   ,[object_name] VARCHAR(255)  
   ,[index_id] INT  
   ,[index_name] VARCHAR(255)  
   ,[rows] INT  
   ,[sizemb] DECIMAL(19, 3)  
   ,[indexdepth] INT  
   ,[type] INT  
   ,[type_desc] VARCHAR(30)  
   ,[fill_factor] INT  
   ,[is_padded] BIT  
   ,[ignore_dup_key] BIT  
   ,[statistics_norecompute] BIT  
   ,[allow_row_locks] BIT  
   ,[allow_page_locks] BIT  
   ,[data_space_name] SYSNAME  
   ,[index_type_desc] VARCHAR(60)  
   ,[is_unique] INT  
   ,[is_primary_key] INT  
   ,[is_unique_constraint] INT  
   ,[index_columns_key] VARCHAR(max)  
   ,[index_columns_include] VARCHAR(max)  
   )  
   
  INSERT INTO @Results  
  SELECT sys.schemas.schema_id  
   ,sys.schemas.[name] AS schema_name  
   ,sys.objects.[object_id]  
   ,sys.objects.[name] AS object_name  
   ,sys.indexes.index_id  
   ,Isnull(sys.indexes.[name], '---') AS index_name  
   ,partitions.rows  
   ,partitions.sizemb  
   ,Indexproperty(sys.objects.[object_id], sys.indexes.[name], 'IndexDepth') AS IndexDepth  
   ,sys.indexes.type  
   ,sys.indexes.type_desc  
   ,IIF(sys.indexes.fill_factor = 0, 100, sys.indexes.fill_factor)  
   ,sys.indexes.is_padded  
   ,sys.indexes.ignore_dup_key  
   ,(  
    SELECT sys.stats.no_recompute  
    FROM sys.stats  
    WHERE sys.stats.object_id = sys.indexes.object_id  
     AND sys.stats.stats_id = sys.indexes.index_id  
    )  
   ,sys.indexes.allow_row_locks  
   ,sys.indexes.allow_page_locks  
   ,(  
    SELECT sys.data_spaces.name  
    FROM sys.data_spaces  
    WHERE sys.data_spaces.data_space_id = sys.indexes.data_space_id  
    )  
   ,sys.indexes.type_desc  
   ,sys.indexes.is_unique  
   ,sys.indexes.is_primary_key  
   ,sys.indexes.is_unique_constraint  
   ,Isnull(Index_Columns.index_columns_key, '---') AS index_columns_key  
   ,Isnull(Index_Columns.index_columns_include, '---') AS index_columns_include  
  FROM sys.objects  
  JOIN sys.schemas ON sys.objects.schema_id = sys.schemas.schema_id  
  JOIN sys.indexes ON sys.objects.[object_id] = sys.indexes.[object_id]  
  JOIN (  
   SELECT [object_id]  
    ,index_id  
    ,Sum(row_count) AS Rows  
    ,CONVERT(NUMERIC(19, 3), CONVERT(NUMERIC(19, 3), Sum(in_row_reserved_page_count +   
       lob_reserved_page_count + row_overflow_reserved_page_count)) / CONVERT(NUMERIC(  
       19, 3), 128)) AS SizeMB  
   FROM sys.dm_db_partition_stats  
   GROUP BY [object_id]  
    ,index_id  
   ) AS partitions ON sys.indexes.[object_id] = partitions.[object_id]  
   AND sys.indexes.index_id = partitions.index_id  
  CROSS APPLY (  
   SELECT LEFT(index_columns_key, Len(index_columns_key) - 1) AS index_columns_key  
    ,LEFT(index_columns_include, Len(index_columns_include) - 1) AS index_columns_include  
   FROM (  
    SELECT (  
      SELECT sys.columns.[name] + ' ' + IIF(sys.index_columns.is_descending_key = 1, 'DESC',   
        'ASC') + ',' + ' '  
      FROM sys.index_columns  
      JOIN sys.columns ON sys.index_columns.column_id = sys.columns.column_id  
       AND sys.index_columns.[object_id] = sys.columns.[object_id]  
      WHERE sys.index_columns.is_included_column = 0  
       AND sys.indexes.[object_id] = sys.index_columns.[object_id]  
       AND sys.indexes.index_id = sys.index_columns.index_id  
      ORDER BY key_ordinal  
      FOR XML path('')  
      ) AS index_columns_key  
     ,(  
      SELECT sys.columns.[name] + ',' + ' '  
      FROM sys.index_columns  
      JOIN sys.columns ON sys.index_columns.column_id = sys.columns.column_id  
       AND sys.index_columns.[object_id] = sys.columns.[object_id]  
      WHERE sys.index_columns.is_included_column = 1  
       AND sys.indexes.[object_id] = sys.index_columns.[object_id]  
       AND sys.indexes.index_id = sys.index_columns.index_id  
      ORDER BY index_column_id  
      FOR XML path('')  
      ) AS index_columns_include  
    ) AS Index_Columns  
   ) AS Index_Columns  
  WHERE sys.schemas.[name] LIKE CASE   
    WHEN @SCHEMANAME = ''  
     THEN sys.schemas.[name]  
    ELSE @SCHEMANAME  
    END  
   AND sys.objects.[name] LIKE CASE   
    WHEN @tableName = ''  
     THEN sys.objects.[name]  
    ELSE @tableName  
    END  
  ORDER BY sys.schemas.[name]  
   ,sys.objects.[name]  
   ,sys.indexes.[name]  
   
  --@Results table has both PK,s Uniques and indexes in thme...pull them out for adding to funal results:      
  SET @CONSTRAINTSQLS = ''  
  SET @INDEXSQLS = ''  
   
  SELECT @CONSTRAINTSQLS = @CONSTRAINTSQLS + CASE   
    WHEN is_primary_key = 1  
     OR is_unique = 1  
     THEN 'CONSTRAINT [' + index_name + ']' + CASE   
       WHEN is_primary_key = 1  
        THEN ' PRIMARY KEY'  
       ELSE CASE   
         WHEN is_unique = 1  
          THEN ' UNIQUE'  
         ELSE ''  
         END  
       END + IIF(ISNULL(type_desc, '') = '', '', ' ' + type_desc) + ' (' + index_columns_key + ')'   
      + CASE   
       WHEN index_columns_include <> '---'  
        THEN ' INCLUDE(' + index_columns_include + ')'  
       ELSE ''  
       END + CASE   
       WHEN fill_factor <> 0  
        THEN ' WITH FILLFACTOR = ' + CONVERT(VARCHAR(30), fill_factor)  
       ELSE ''  
       END  
    ELSE ''  
    END + @vbCrLf + @vbTab + ','  
  FROM @RESULTS  
  WHERE [type_desc] != 'HEAP'  
   AND is_primary_key = 1  
   OR is_unique = 1  
  ORDER BY is_primary_key DESC  
   ,is_unique DESC  
   
  SELECT @INDEXSQLS = @INDEXSQLS + CASE   
    WHEN is_primary_key = 0  
     OR is_unique = 0  
     THEN 'CREATE ' + index_type_desc + ' INDEX [' + index_name + '] ON [' + [schema_name] + '].[' +   
      [object_name] + ']' + ' (' + index_columns_key + ')' + CASE   
       WHEN index_columns_include <> '---'  
        THEN @vbCrLf + @vbTab + 'INCLUDE (' + index_columns_include + ')'  
       ELSE ''  
       END + CASE   
       WHEN fill_factor <> 0  
        THEN @vbCrLf + @vbTab + 'WITH (PAD_INDEX = ' + IIF(is_padded = 1, 'ON', 'OFF') +   
         ', FILLFACTOR = ' + CONVERT(VARCHAR(30), fill_factor) +   
         ', SORT_IN_TEMPDB = OFF' + ', IGNORE_DUP_KEY = ' + IIF(ignore_dup_key = 1,   
          'ON', 'OFF') + ', STATISTICS_NORECOMPUTE = ' + IIF(  
          statistics_norecompute = 1, 'ON', 'OFF') + ', ONLINE = OFF ' +   
         ', ALLOW_ROW_LOCKS = ' + IIF(allow_row_locks = 1, 'ON', 'OFF') +   
         ', ALLOW_PAGE_LOCKS = ' + IIF(allow_page_locks = 1, 'ON', 'OFF') + ')' +   
         @vbCrLf + @vbTab + 'ON [' + data_space_name + ']'  
       ELSE ''  
       END  
    END + ';' + @vbCrLf + @vbCrLf  
  FROM @RESULTS  
  WHERE [type_desc] != 'HEAP'  
   AND is_primary_key = 0  
   AND is_unique = 0  
  ORDER BY is_primary_key DESC  
   ,is_unique DESC  
   
  IF @INDEXSQLS <> ''  
   SET @INDEXSQLS = @vbCrLf + @INDEXSQLS  
  SET @CHECKCONSTSQLS = ''  
   
  SELECT @CHECKCONSTSQLS = @CHECKCONSTSQLS + Isnull('CONSTRAINT [' + sys.objects.[name] + ']' + ' CHECK ' +   
    Isnull(sys.check_constraints.DEFINITION, '') + @vbCrLf + @vbTab + ',', '')  
  FROM sys.objects  
  INNER JOIN sys.check_constraints ON sys.objects.[object_id] = sys.check_constraints.[object_id]  
  WHERE sys.objects.type = 'C'  
   AND sys.objects.parent_object_id = @TABLE_ID  
   
  SET @FKSQLS = '';  
   
  SELECT @FKSQLS = @FKSQLS + 'CONSTRAINT [' + Object_name(constid) + ']' + ' FOREIGN KEY (' + Col_name(fkeyid,   
    fkey) + ') REFERENCES ' + Object_name(rkeyid) + '(' + Col_name(rkeyid, rkey) + ')' + @vbCrLf + @vbTab +   
   ','  
  FROM sysforeignkeys  
  WHERE fkeyid = @TABLE_ID  
   
  SELECT @FINALSQL = @FINALSQL + @CONSTRAINTSQLS + @CHECKCONSTSQLS + @FKSQLS  
   
  SET @FINALSQL = Substring(@FINALSQL, 1, Len(@FINALSQL) - 1);  
  SET @FINALSQL = @FINALSQL + ');' + @vbCrLf;  
   
  SELECT @FINALSQL + @INDEXSQLS  
 END TRY  
 BEGIN CATCH  
  SET @returnCode = 99;  
  SET @returnMessage = N'(ERROR_PROCEDURE: ' + ERROR_PROCEDURE() + '; ERROR_NUMBER=' + CONVERT(VARCHAR(4000), ERROR_NUMBER()) + '; ERROR_SEVERITY=' + CONVERT(VARCHAR(4000), ERROR_SEVERITY()) + '; ERROR_STATE=' + CONVERT(VARCHAR(4000), ERROR_STATE()) + '; 
ERROR_LINE=' + CONVERT(VARCHAR(4000), ERROR_LINE()) + '; ERROR_MESSAGE=' + ERROR_MESSAGE() + ')';  
 END CATCH  
END