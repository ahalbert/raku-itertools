use v6;
my $VERSION = "1.0.0";
unit module python::itertools;

=begin pod 

=head1 NAME
python::itertools

=head1 SYNOPSIS

A direct port of Python's itertools to perl6.

=head1 DESCRIPTION

It provides all the functionality that python's itertools does, including lazy evaluation.  In the future, I'd like to maximize the performance of these
functions.  Function signatures may be a little different.

I needed a itertools.combinations_with_replacement and couldn't find an easy builtin or library to do it.  So why not write the library myself? It turns out
raku has most of these functions built in already. Unfortunatley, I did not realize that until after writing it. Oops.

=head1 FUNCTIONS

=head2 accumulate(@iterable, $func=&[+])
Gathers accumulated sums, or accumulated results of other binary functions (specified via the optional $func argument). If $func is
supplied, it should be a function of two arguments.

=begin code
accumulate((1,2,3,4,5)) --> (1, 3, 6, 10, 15)
accumulate((1,2,3,4,5), &[*]) --> (1, 2, 6, 24, 120)
=end code

=head2 batched(@iterable, $n)
groups items of @iterable into lists of size $n. If there's not enough to create a list of size $n, then takes the remaining items.

=begin code
batched(('a','b','c','d','e','f','g'), 2) -> (('a', 'b'), ('c', 'd'), ('e', 'f'), ('g'))
=end code

=head2 combinations(@iterable, $r)
Gathers all combinations of length $r from @iterable, not allowing repeated elements

=begin code
combinations(('a','b','c','d'), 2) -> (('a','b'), ('a','c'), ('a','d'), ('b','c'), ('b','d'), ('c','d'));
=end code

=head2 combinations_with_replacement(@iterable, $r)
Gathers all combinations of length $r from @iterable, allowing elements to repeat.

=begin code
combinations_with_replacement(('a','b','c'), 2) -> (('a','a'), ('a','b'), ('a','c'), ('b','a'), ('b','b'), ('b','c'), ('c','a'), ('c','b'), ('c','c'));
=end code

=head2 chain(*@iterables)
Merges all of *@iterables into a single list. 

=begin code
chain(("A","B","C"), ("D","E","F")) --> ("A", "B", "C", "D", "E", "F")
=end code

=head2 count($start is copy, $step=1)
Gathers values from $start, increasing by $step each time. Infinte list.

=begin code
count(10)[^5] --> (10, 11, 12, 13, 14)
count(10, 2)[^5], (10,12,14,16,18);
=end code

=head2 compress(@elements, @selectors)
Returns all members of @elements where the corresponding ?@selector is True.

=begin code
compress(['a','b','c','d'], [True,False,True,False]) -> ['a','c']
=end code

=head2 cycle(@iterable )
Creates an infinite repeating List from @iterable

=begin code
cycle(['a','b','c','d'])[^6] -> ['a','b','c','d','a','b']
=end code

=head2 dropwhile(@elements, $predicate=Bool)
Shifts @elements until $predicate evaluates to False and gathers remaining elements

=begin code
dropwhile([1,4,6,4,1], {$_ < 5;}) --> [6,4,1];
=end code

=head2 filterfalse($predicate, @iterable)
Filters elements from @iterable where $predicate is False

=begin code
filterfalse({ $_ % 2 == 1}, 0..5) -> [0,2,4];
=end code

=head2 groupby(@iterable, $key={ $_} )
Groups elements into Lists by a function defined in $key. Default is the identity function.

=begin code
groupby(['a','b','a','a','a','b','b','c','a']) -> (('a','a','a','a','a'),('b','b','b'),('c'));
groupby(0..5, { $_ % 2 }) -> ((0, 2, 4),(1, 3, 5));
=end code

=head2 islice(@iterable, $stop)
=head2 islice(@iterable, $start, $stop, :$step=1)
Slices @iterable from $start to $stop, skipping $step-1 elements. If only $stop is defined, starts from 0.
If $stop is Nil, uses the entire @iterable;

=begin code
islice(('a','b','c','d','e','f','g') , 2) -> ('a', 'b');
islice(('a','b','c','d','e','f','g') , 2, 4) -> ('c', 'd');
islice(('a','b','c','d','e','f','g') , 2, Nil) -> ('c', 'd', 'e', 'f', 'g');
islice(('a','b','c','d','e','f','g') , 0, Nil, step => 2) -> ('a', 'c', 'e', 'g');
=end code

=head2 pairwise(@iterable)
Creates sucessive overlapping pairs of elements from @iterable. If @iterable has less than 2 elements, returns empty list

=begin code
pairwise(('a','b','c','d','e','f','g')) -> (('a', 'b'), ('b', 'c'), ('c', 'd'), ('d', 'e'), ('e', 'f'), ('f', 'g'));
pairwise(['a']) -> ();
=end code

=head2 permutations(@iterable, $r)
Creates sucessive $r-length permutations from iterable. If $r is Nil, uses the length of @iterable as $r

=begin code
permutations(('A', 'B', 'C', 'D'), 2) -> (('A', 'B') , ('A', 'C'), ('A','D'), ('B', 'A'), ('B', 'C'), ('B', 'D'), ('C', 'A'), ('C', 'B'), ('C', 'D'), ('D', 'A'), ('D', 'B'), ('D', 'C'));
=end code

=head2 product(**@iterables, :$repeat=1)
Duplicates each item in @iterables $repeat times and then creates the cartesian product of all items.

=begin code
product([0,1], :repeat(3)) -> ((0,0,0), (0,0,1), (0,1,0), (0,1,1), (1,0,0), (1,0,1), (1,1,0), (1,1,1));
product([0,1], [0,1]) -> ((0,0), (0,1), (1,0), (1,1));
product([0,1], [0,1], :repeat(2)) -> ((0, 0, 0, 0), (0, 0, 0, 1), (0, 0, 1, 0), (0, 0, 1, 1), (0, 1, 0, 0), (0, 1, 0, 1), (0, 1, 1, 0), (0, 1, 1, 1), (1, 0, 0, 0), (1, 0, 0, 1), (1, 0, 1, 0), (1, 0, 1, 1), (1, 1, 0, 0), (1, 1, 0, 1), (1, 1, 1, 0), (1, 1, 1, 1));
=end code

=head2 repeat($obj, Int $times=0)
Gathers $obj $times times or Infintely if $times is 0.

=begin code
repeat("3")[^5] -> [3,3,3,3,3];  
repeat("3",3) -> [3,3,3];  
=end code

=head2 starmap($function, @iterable)
Gathers items where each item in @iterable is computed with $function. Used instead of map when argument parameters are already grouped in tuples from a single iterable (the data has been “pre-zipped"

=begin code
starmap(&sum, ((1,2,3), (4,5,6))) -> (6, 15)
=end code

=head2 tee(@iterable, $n)
Gathers $n independent @iterable;

=begin code
tee(1..5 ,3) -> (1..5, 1..5, 1..5);
=end code

=head2 takewhile(@elements, $predicate=Bool)
Gathers items from @elements until $predicate evaluates to False. 

=begin code
takewhile([1,4,6,4,1], {$_ < 5;}) -> [1,4];
=end code

=head2 zip_longest(@elements, :$fillvalue=Nil)
zips elements from each of @iterables. If the iterables are of uneven length, fillvalue replaces the missing values.
Iteration continues until the longest iterable is exhausted. 

=begin code
zip_longest((1,2,3,4),(1,2), (-1,-2,-3), :fillvalue("0")) -> ((1,1,-1), (2,2,-2), (3,"0",-3), (4, "0","0"));
=end code
=end pod

sub accumulate(@iterable, :$func=&[+], :$initial=Nil) is export {
    gather {
        my $accumulator; 
        if $initial === Nil { 
          $accumulator = @iterable.shift;
        }
        else { 
          $accumulator = $initial 
        }
        take $accumulator;
        for @iterable {
            $accumulator = $func($accumulator, $_);
            take $accumulator;
        }
    }
}

sub batched(@iterable, $n) is export {
  my $index = 0;
  die "n must be greater than 0." if $n < 1;
  gather {
    while $index < @iterable.elems {
      take (@iterable[$index..$index+$n-1].grep({ $_ !=== Nil }).List);
      $index += $n;
    }
  }
}

sub chain(*@iterables) is export { @iterables }

sub count($start is copy, $step=1) is export { $start, *+$step ... *; }

#TODO: combinations
sub combinations(@iterable, $r) is export {
    gather { combinations_helper(@iterable, [], $r, False); }
}

sub combinations_with_replacement(@iterable, $r) is export { 
    gather { combinations_helper(@iterable, [], $r, True); }
}

sub combinations_helper(@iterable, @state, $r, $replacement=False) {
    for 0..@iterable.elems-1 {
        @state.push(@iterable[$_]);
        if $r > 1 {
            if $replacement { combinations_helper(@iterable[$_..*-1], @state, $r-1, $replacement); }
            else { combinations_helper(@iterable[$_+1..*-1], @state, $r-1, $replacement); }
            @state.pop;
        } else {
            my @return = @state.List;
            @state.pop;
            take @return;
        }
    }
}

sub compress(@elements, @selectors) is export {
    gather {
        for zip(@elements, @selectors) -> ($element, $selector) {
            take $element if (?$selector);
        }
    }
}

sub cycle(@iterable) is export {
    die "iterable must be a list" unless @iterable;
    gather {
        while True {
            take $_ for @iterable; 
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

sub filterfalse($predicate, @iterable) is export {
  @iterable.grep({ not $predicate($_); }).List;
}

sub groupby(@iterable is copy, $key={ $_ }) is export {
    gather {
        my @rest = @iterable.Array;
        while ?@rest {
            my $head = $key(@rest.first);
            take (@rest ==> grep { $head eqv $key($_)}).List;
            @rest = (@rest ==> grep { not ($head eqv $key($_))});
        }
    }
}

multi sub islice(@iterable, $stop) is export {
  islice(@iterable, 0, $stop);
}

multi sub islice(@iterable, $start, $stop, :$step=1) is export {
  my $index = 0 ;
  gather {
    for @iterable {
      if ($index >= $start and ($stop === Nil or $index < $stop) and ($index - $start) % $step == 0) { take $_;}
      $index++;
    }
  }
  
}

sub pairwise(@iterable) is export {
  my $index = 0;
  return List if @iterable.elems < 2;
  gather {
    while $index < @iterable.elems - 1 {
      take @iterable[$index..$index+1];
      $index += 1;
    }
  }
}

sub permutations(@iterable, $r=Nil) is export {
  $r = @iterable.elems if $r === Nil;
  gather { permutations_helper(@iterable, [], $r); } 
}

sub permutations_helper(@iterable, @state, $r) {
    for 0..@iterable.elems-1 {
        @state.push(@iterable[$_]);
        if $r > 1 {
            if $_ == 0 {
              permutations_helper(@iterable[1..*-1], @state, $r-1);
            }
            elsif $_  == @iterable.elems - 1 {
              permutations_helper(@iterable[0..*-2], @state, $r-1);
            }
            else { 
              permutations_helper((|@iterable[0..$_-1], |@iterable[$_+1..*-1]), @state, $r-1);
            }
            @state.pop;
        } else {
            my @return = @state.List;
            @state.pop;
            take @return;
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

sub repeat($obj, Int $times=0) is export {
    die "times-repeated in repeats must be > -1." unless $times >= 0;
    gather {
        if $times == 0 {
            take $obj while True; 
        } else {
            take $obj for 1..$times;  
        }
    }
}

sub starmap($function, @iterable) is export { @iterable.map({.$function}) }

sub takewhile(@elements, $predicate=Bool) is export {
    gather {
        for @elements {
            last unless $predicate($_);
            take $_;
        }
    }
}

sub tee(@iterable is copy, Int $n) is export {
    gather { 
        take @iterable for 1..$n;
    }
}

sub zip_longest(**@iterables, :$fillvalue = Nil) is export {
    my $longest = (@iterables ==> map -> @it { @it.elems } ==> max);
    my $index = 0;
    gather {
        while $index < $longest {
            my @result = ();    
            for @iterables -> @it {
                if $index < @it.elems {
                    @result.push(@it[$index]);
                } else {
                    @result.push($fillvalue);
                }
            }
            take @result;
            ++$index;
        }
    }
}

