use v6;
my $VERSION = "0.9";
unit module python::itertools;

sub count($start is copy, $step=1) is export {
    $start, *+$step ... *;
}

sub repeats($obj, Int $times=0) is export {
    die "times-repeated in repeats must be > -1." unless $times >= 0;
    gather {
        if $times == 0 {
            take $obj while True; 
        } else {
            take $obj for 1..$times ; 
        }
    }
}

sub cycle(@elements) is export {
    die "elements must be a list" unless @elements;
    gather {
        while True {
            take $_ for @elements; 
        }
    }
}

sub compress(@elements, @selectors)  is export {
    gather {
        for zip(@elements, @selectors) -> ($element, $selector) {
            take $element if (?$selector);
        }
    }
}
 
sub chain(**@iterables) is export {
    gather {
        for @iterables -> @iterable {
            take $_ for @iterable;
        } 
    }
}

sub accumulate(@elements, $op=&[+]) is export {
    gather {
        my $head = @elements.first;
        take $head;
        for @elements[1..*-1] {
            $head = $op($head, $_);
            take $head;
        }
    }
}

#should be classify with a default arg
sub groupby(@elements is copy, $key={ $_ }) is export {
    gather {
        my @rest = @elements.Array;
        while ?@rest {
            my $head = $key(@rest.first);
            take (@rest ==> grep { $head eq $key($_)}).List;
            @rest = (@rest ==> grep { $head ne $key($_)});
        }
    }
}

sub dropwhile(@elements, $predicate=Bool) is export {
    gather {
        my $index = 0;
        ++$index while $index < @elements.elems and $predicate(@elements[$index]);
        take $_ for @elements[$index..*-1];
    }
}

sub takewhile(@elements, $predicate=Bool) is export {
    gather {
        for @elements {
            last unless $predicate($_);
            take $_;
        }
    }
}

sub product(**@iterables, :$repeat=1) is export {
    die unless $repeat > 0;
    if $repeat > 1 { 
        my @repeated = ();
        @iterables = (@iterables ==> map -> @it {@it xx $repeat} );  
        for @iterables -> @it {
            for @it -> @r { @repeated.push(@r); }
        }
        @iterables = @repeated;
    } 
    gather {
         take $_ for ([X] @iterables);
    }
}

#for future enhancements of product()
# sub prod(Int $repeat, **@iterables) {
# }

sub starmap($f, **@iterables) is export {
    @iterables.map(-> @it {$f(@it);} );
}

sub tee(@iterable is copy, Int $n) is export {
    gather { 
        take @iterable for 1..$n;
    }
}

sub zip_longest($fill, **@iterables) is export {
    my $longest = (@iterables ==> map -> @it { @it.elems } ==> max);
    my $index=0;
    gather {
        while $index < $longest {
            my @result = ();    
            for @iterables -> @it {
                if $index < @it.elems {
                    @result.push(@it[$index]);
                } else {
                    @result.push($fill);
                }
            }
            take @result;
            ++$index;
        }
    }
}

sub combinations_with_replacement(@iterable, $r) is export {
    gather {
        cwr(@iterable, [], $r);
    }
}

sub cwr(@iterable, @state, $r) {
    my $place = @state.elems;
    @state.push(Nil);
    for @iterable {
        @state[$place] = $_;
        if $r > 1 {
            cwr(@iterable, @state, $r-1);
            @state.pop;
        } else {
            take @state.List;
        }
    }
}
