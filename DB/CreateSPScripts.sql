use fpcapps

--get the sql scripts of all the SPs in BM
Select	OBJECT_DEFINITION(pr.object_id)
from 
sys.procedures pr 
inner join sys.schemas s on s.schema_id = pr.schema_id
where s.name = 'BM'

