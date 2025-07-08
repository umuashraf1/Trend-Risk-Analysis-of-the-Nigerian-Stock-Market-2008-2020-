--Prepare SQL Queries for the Analytics TeamProvide the analytics team with ready-to-use SQL queries for the following KPIs

select * from nigeria_stock

-- • Highest daily return
select date, change_pct as highest_daily_returns
from nigeria_stock
order by change_pct desc
limit 1


-- • Average monthly close
select
extract(year from date) as year,
extract(month from date) as months,
round(avg(price)) as avg_monthly_close
from nigeria_stock
group by months, year
order by months , year


-- • Monthly volatility trend
select
extract(year from date) as year,
extract(month from date) as months,
(stddev(change_pct)) as monthly_volatility
from nigeria_stock
group by months, year
order by months , year


-- • 5 lowest drawdown periods
with daily_drawdown as (
    select 
        date,
        price,
        (price - max(price) over (order by date rows between 30 preceding and current row)) / 
        max(price) over (order by date rows between 30 preceding and current row) as drawdown_pct
    from nigeria_stock
)
select date, drawdown_pct
from daily_drawdown
order by drawdown_pct asc
limit 5

-- • Last 30-day average return
select avg(change_pct) as avg_30day_return
from nigeria_stock
where date >= (select max(date) from nigeria_stock) - interval '30 days'
