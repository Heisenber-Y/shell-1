SELECT count(*) FROM ccb_record_status a where a.business_date = &1 and a.filename like 'FESP%'||&1||'%N.dat'; 
exit
