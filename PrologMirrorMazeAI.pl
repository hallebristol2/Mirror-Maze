% Halle Bristol
% Assignment 4, Lazers. Prioritizes going straight over placing mirrors.
% Improve for less?


% CREATE THE 10x12 GRID (Is there a better way?)
point(1,1). point(1,2). point(1,3). point(1,4). point(1,5).
point(1,6). point(1,7). point(1,8). point(1,9). point(1,10).
point(2,1). point(2,2). point(2,3). point(2,4). point(2,5).
point(2,6). point(2,7). point(2,8). point(2,9). point(2,10).
point(3,1). point(3,2). point(3,3). point(3,4). point(3,5).
point(3,6). point(3,7). point(3,8). point(3,9). point(3,10).
point(4,1). point(4,2). point(4,3). point(4,4). point(4,5).
point(4,6). point(4,7). point(4,8). point(4,9). point(4,10).
point(5,1). point(5,2). point(5,3). point(5,4). point(5,5).
point(5,6). point(5,7). point(5,8). point(5,9). point(5,10).
point(6,1). point(6,2). point(6,3). point(6,4). point(6,5).
point(6,6). point(6,7). point(6,8). point(6,9). point(6,10).
point(7,1). point(7,2). point(7,3). point(7,4). point(7,5).
point(7,6). point(7,7). point(7,8). point(7,9). point(7,10).
point(8,1). point(8,2). point(8,3). point(8,4). point(8,5).
point(8,6). point(8,7). point(8,8). point(8,9). point(8,10).
point(9,1). point(9,2). point(9,3). point(9,4). point(9,5).
point(9,6). point(9,7). point(9,8). point(9,9). point(9,10).
point(10,1). point(10,2). point(10,3). point(10,4). point(10,5).
point(10,6). point(10,7). point(10,8). point(10,9). point(10,10).
point(11,1). point(11,2). point(11,3). point(11,4). point(11,5).
point(11,6). point(11,7). point(11,8). point(11,9). point(11,10).
point(12,1). point(12,2). point(12,3). point(12,4). point(12,5).
point(12,6). point(12,7). point(12,8). point(12,9). point(12,10).


% CREATE EACH POSSIBLE PLACE FOR PERSON TO EXIST IN GRID (2x6, 3<=x<=9)
person([point(3,5), point(3,6), point(3,7), point(3,8), point(3,9), point(3,10),
        point(4,5), point(4,6), point(4,7), point(4,8), point(4,9), point(4,10)]).

person([point(4,5), point(4,6), point(4,7), point(4,8), point(4,9), point(4,10),
        point(5,5), point(5,6), point(5,7), point(5,8), point(5,9), point(5,10)]).

person([point(5,5), point(5,6), point(5,7), point(5,8), point(5,9), point(5,10),
        point(6,5), point(6,6), point(6,7), point(6,8), point(6,9), point(6,10)]).

person([point(6,5), point(6,6), point(6,7), point(6,8), point(6,9), point(6,10),
        point(7,5), point(7,6), point(7,7), point(7,8), point(7,9), point(7,10)]).

person([point(7,5), point(7,6), point(7,7), point(7,8), point(7,9), point(7,10),
        point(8,5), point(8,6), point(8,7), point(8,8), point(8,9), point(8,10)]).

person([point(8,5), point(8,6), point(8,7), point(8,8), point(8,9), point(8,10),
        point(9,5), point(9,6), point(9,7), point(9,8), point(9,9), point(9,10)]).

person([point(9,5), point(9,6), point(9,7), point(9,8), point(9,9), point(9,10),
        point(10,5), point(10,6), point(10,7), point(10,8), point(10,9), point(10,10)]).


% RECTANGLE FOR OBSTACLES, AND CHECK IF IN OBSTACLE
rect([x,y,w,h]).
inRect(rect([X,Y,W,H]),[XL,YL]) :-
    XL > X,
    XL =< X+W,
    YL > Y,
    YL =< Y+H.
inObst([X,Y],[LEFTBOUND,W,H]) :- inRect(rect([LEFTBOUND, 0, W, H]), [X,Y]).


% LEGAL MOVES (try recurisve)
legalPoint(_,[]). % Terminating condition (no more obstacles to compare)
legalPoint([X,Y],[OBS|OBSTAIL]) :-
    point(X,Y), not(inObst([X,Y],OBS)),
    legalPoint([X,Y],OBSTAIL).


% STEP FUNCTION FOR LAZER (no left)
step([X,Y],r,[NEWX,Y]) :- NEWX is X+1.
step([X,Y],u,[X,NEWY]) :- NEWY is Y-1.
step([X,Y],d,[X,NEWY]) :- NEWY is Y+1.


% REFLECT FUNCTION FOR MOVING (no left!)
refl(d,\,r). % Start direction, mirror placement, resulting direction
refl(u,/,r). % STARTS WITH UPPERCASE = VARIABLES
refl(r,\,d).
refl(r,/,u).


% BASE CASE MOVEMENT
move(H,point(12,H),r,MIRRORS,MIRRORS,_,_).


% STRAIGHT LINE MOVEMENT
move(H,point(X,Y),DIR,INPUTMIRR,RETMIRR,OBS,person(P)) :-
    step([X,Y],DIR,[XNEW,YNEW]),
    legalPoint([XNEW,YNEW],OBS),
    not(member(point(XNEW,YNEW),P)),
    move(H,point(XNEW,YNEW),DIR,INPUTMIRR,RETMIRR,OBS,person(P)).


% REFLECTING MOVEMENT
move(H,point(X,Y),DIR,INPUTMIRR,RETMIRR,OBS,person(P)) :-
    length(INPUTMIRR,MIRRTOTAL),
    MIRRTOTAL < 8,
    refl(DIR,MIRR,DIRNEW),
    step([X,Y],DIRNEW,[XNEW,YNEW]),
    legalPoint([XNEW,YNEW],OBS),
    append(INPUTMIRR,[[X,Y,MIRR]],MIRRNEW),
    not(member(point(XNEW,YNEW),P)),
    move(H,point(XNEW,YNEW),DIRNEW,MIRRNEW,RETMIRR,OBS,person(P)).


% PLACE MIRROR FUNCTION
place_mirrors(H,OBS,POS) :-
    person(P),
    move(H,point(1,H),r,[],POS,OBS,person(P)).

% INPUT FORMAT:
% EXAMPLE: place_mirrors(8, [[2,2,3],[9,2,4]],X).
