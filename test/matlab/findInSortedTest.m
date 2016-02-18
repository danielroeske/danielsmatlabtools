function findInSortedTest()
    reference=@(x,scalar)(find(x == scalar));
    reference2=@(x,range)(find(x >= range(1)&x<=range(2)));
    T={[1 2 2 3 3 3 4 5 6 7 7],3};
    for ix=0:4
        T(end+1,:)={1:3,ix};
    end
    for ix=[-inf,0:4,+inf]
        T(end+1,:)={1:3,ix};
    end
    for ix=[-inf,0:4,+inf]
        for iy=[-inf,0:4,+inf]
            T(end+1,:)={1:3,[ix,iy]};
        end
    end
    for ix=[-inf,0:4,+inf]
        for iy=[-inf,0:4,+inf]
            T(end+1,:)={1:3,[ix,iy]};
        end
    end
    for tc = 1:size(T,1)
        if numel(T{tc,2})==1

            r=reference(T{tc,:});
            [a,b]=findInSorted(T{tc,:});
            assert(all(a:b==r))
            T{tc,2}=[T{tc,2},T{tc,2}];
        end
        r=reference2(T{tc,:});
        [a,b]=findInSorted(T{tc,:});
        assert(all(a:b==r))
    end
end
