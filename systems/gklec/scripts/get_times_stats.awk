#!/bin/awk -f

BEGIN{sum=0; sumsq=0; count=0}
{
 ((sum += $1))
 ((sumsq += ($1)^2))
 ((count += 1))
}
END{
    avg = sum/count
    stdev=sqrt((sumsq-sum^2/count)/count)
    printf "Average reasoning time: %f \n", avg
    printf "Standard deviation: %f \n", stdev
}



