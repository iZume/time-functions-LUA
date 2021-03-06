-- impromptu time functions! 
-- by Chainsaw

local lang = tonumber(get("time.Lang"));

local DaysWeek = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};

local MonthsYear = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}; 

local DefaultMessage = "Unknown";

local baseDay, baseMonth, baseYear = 1, 1, 1970;

if(lang == 2) then -- ES
    DaysWeek = {"Domingo", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado"};

    MonthsYear = {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"}

    DefaultMessage = "Desconocido";
end

function getWeekDay(day, month, year) -- Based in Zeller Congruence
    local a = math.floor((14 - month) / 12);

    local y = year - a;

    local m = month + (12 * a) - 2;

    local d5 = math.floor((day + y + math.floor(y/4) - math.floor(y/100) + math.floor(y/400) + ((31 * m) / 12)) % 7);
    
    d5 = DaysWeek[d5+1];

    return (not d5) and DefaultMessage or d5;
end 

function getMonthDays(month, year) 

    local days = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}

    local x = 0;
    
    local l = (IsLeapYear(year) and month == 2) and 1 or 0;

    if(month >= 1 and month <= 12) then
        x = days[month] + l; 
    end
    return x; 
end

function getMonthName(month) 
    local name = ( month >= 1 and month <= table.getn(MonthsYear) ) and (MonthsYear[month]) or DefaultMessage;

    return name; 
end

function getYearDays(year) 
    return IsLeapYear(year) and 366 or 365; 
end

function getRemaningDaysInYear(day, month, year) 
    return getYearDays(year) - getSpentsDaysInYear(day, month, year); 
end

function getSpentsDaysInYear(day, month, year) 
    local sigma = day;
    for i = 1,month-1 do
        sigma = sigma + getMonthDays(i, year)
    end
    return sigma; 
end

function dateToUnix(day, month, year) 
    local x = 0;

    for i=baseYear,year-1 do
        x = x + (60 * 60 * 24 * getYearDays(i));
    end 

    for i=1,month-1 do
        x = x + (getMonthDays(month, year) * 86400);
    end

    x = x + ( (day + 4) * 86400 ); 

    return x; 
end

function unixToDate(x) 
    local day, month, year = baseDay, baseMonth, baseYear;
    while(x >= 86400) do
        x = x - 86400; 
        day = day + 1;
        if(day > getMonthDays(month, year)) then 
            day = 1; 
            month = month + 1; 
            if(month > 12) then
                year = year + 1; 
                month = 1; 
            end
        end
    end
    return day, month, year;
end

function IsLeapYear(year)
    return year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0);
end

function getDateInAdd(_day, _month, _year, days, months, years) 
    return unixToDate(dateToUnix(_day, _month, _year) + (   (days * 86400) + (months * 2592000) + (years * 31104000)   )); 
end