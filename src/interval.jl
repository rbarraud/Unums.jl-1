immutable Interval{T}
    lo::T
    hi::T
    # function Interval(lo,hi)
    #     if isnan(lo)
    #         Interval(lo,lo)
    #     elseif isnan(hi)
    #         Interval(hi,hi)
    #     else
    #         Interval(lo,hi)
    #     end
    # end
end

function +(x::Interval, y::Interval)
    Interval(+(x.lo,y.lo,RoundDown), +(x.hi,y.hi,RoundUp))
end
function -(x::Interval, y::Interval)
    Interval(-(x.lo,y.hi,RoundDown), -(x.hi,y.lo,RoundUp))
end

ispos(x::Interval) = x.lo > 0
isneg(x::Interval) = x.hi < 0
isposz(x::Interval) = x.lo >= 0
isnegz(x::Interval) = x.hi <= 0


function *(x::Interval, y::Interval)
    if isposz(x) # x >= 0
        if isposz(y)
            Interval(*(x.lo,y.lo,RoundDown),*(x.hi,y.hi,RoundUp))
        elseif isnegz(y)
            Interval(*(x.hi,y.lo,RoundDown),*(x.lo,y.hi,RoundUp))
        else
            Interval(*(x.hi,y.lo,RoundDown),*(x.hi,y.hi,RoundUp))
        end
    elseif isnegz(x) # x <= 0
        if isposz(y)
            Interval(*(x.lo,y.hi,RoundDown),*(x.hi,y.lo,RoundUp))
        elseif isnegz(y)
            Interval(*(x.hi,y.hi,RoundDown),*(x.lo,y.lo,RoundUp))
        else
            Interval(*(x.lo,y.hi,RoundDown),*(x.lo,y.lo,RoundUp))
        end
    else
        if isposz(y)
            Interval(*(x.lo,y.hi,RoundDown),*(x.hi,y.hi,RoundUp))
        elseif isnegz(y)
            Interval(*(x.hi,y.lo,RoundDown),*(x.lo,y.lo,RoundUp))
        else
            Interval(min(*(x.lo,y.hi,RoundDown),*(x.hi,y.lo,RoundDown)),
                     max(*(x.lo,y.lo,RoundUp),*(x.hi,y.hi,RoundUp)))
        end
    end
end


function /{T}(x::Interval{T}, y::Interval{T})
    if ispos(y) # b strictly positive
        if isposz(x)
            Interval(/(x.lo,y.hi,RoundDown), /(x.hi,y.lo,RoundUp))
        elseif isnegz(x)
            Interval(/(x.lo,y.lo,RoundDown), /(x.hi,y.hi,RoundUp))
        else
            Interval(/(x.lo,y.lo,RoundDown), /(x.hi,y.lo,RoundUp))
        end
    elseif isneg(y)
        if isposz(x)
            Interval(/(x.hi,y.hi,RoundDown), /(x.lo,y.lo,RoundUp))
        elseif isnegz(x)
            Interval(/(x.hi,y.lo,RoundDown), /(x.lo,y.hi,RoundUp))
        else
            Interval(/(x.hi,y.hi,RoundDown), /(x.lo,y.hi,RoundUp))
        end
    else
        Interval(T(NaN),T(NaN))
    end
end


# should be able to remove this if Interval <: Real
Base.inv(x::Interval) = one(x) / x
