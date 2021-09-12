size = arg[1]

function round(number)
    return math.floor(number + 0.5 - (number + 0.5) % 1)
end

function as_string(size, suffix)
    return (size and (round(size) .. suffix .. " ") or "")
end

function split_size(size, max_size)
    if size and size > max_size then
        lower_part = size % max_size
        bigger_part = (size - lower_part) / max_size
    else
        lower_part = size
        bigger_part = nil
    end
    return lower_part, bigger_part
end

n_nanoseconds, n_seconds_ = split_size(tonumber(size), 1000000000)
n_seconds, n_minutes_ = split_size(n_seconds_, 60)
n_minutes, n_hours_ = split_size(n_minutes_, 60)
n_hours, n_days_ = split_size(n_hours_, 24)
n_days, n_months_ = split_size(n_days_, 30)
n_months, n_years_ = split_size(n_months_, 12)
n_years, n_centuries = split_size(n_years_, 100)

string = as_string(n_centuries, 'c') .. as_string(n_years, 'Y') .. as_string(n_months, 'M') .. as_string(n_days, 'd') ..
    as_string(n_hours, 'h') .. as_string(n_minutes, 'm') .. as_string(n_seconds, 's') .. as_string(n_nanoseconds, 'n')

print(string)
