select a.nnid, c.TRACKNAME, b.Month, a.FIRSTPRCNT, a.FIRSTPAY, a.PLACEPRCNT, a.PLACEPAY
from NETWORKRESULTS a
inner join NETWORKDETAILS b on a.NNID = b.id
inner join tracks c on b.track = c.TRACKID
where a.NUMBETS > 100
AND a.PLACEPRCNT > 60
order by a.PLACEPRCNT desc


---------------------------------------------------------------------------

select c.TRACKNAME, b.Month, max(a.placeprcnt) AS MAX_PRCNT
from NETWORKRESULTS a
inner join NETWORKDETAILS b on a.NNID = b.id
inner join tracks c on b.track = c.TRACKID
where NUMBETS > 100
AND a.placeprcnt > 60
AND b.Month = 9
group by c.TRACKNAME, b.Month
order by max(a.PLACEPRCNT) desc



---------------------------------------------------------------------------