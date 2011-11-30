%%
%% ----------------------------------------------------------------------------
%% "THE BEER-WARE LICENSE" (Revision 42.1):
%% <gustav.simonsson@gmail.com> wrote this file.
%% As long as you retain this notice you
%% can do whatever you want with this stuff. If we meet some day, and you think
%% this stuff is worth it, you can buy me a beer in return. 
%% ----------------------------------------------------------------------------
%%
%%%-------------------------------------------------------------------
%%% @author Gustav Simonsson <gustav.simonsson@gmail.com>
%%% @doc
%%%
%%% Miscellaneous Erlang function collection.
%%%
%%% @end
%%% Created : 29 Nov 2011 by Gustav Simonsson <gustav.simonsson@gmail.com>
%%%-------------------------------------------------------------------
-module(gs_util).

-compile(export_all).

words(Words) ->
    lists:flatten([0|| _X <- lists:seq(1, Words div 2)]).

substrings(S) -> 
    Slen = length(S),
    [string:sub_string(S,B,E) || 
        B <- lists:seq(1, Slen), E <- lists:seq(B, Slen)].

get_file_lines(F) ->
    get_file_lines_acc(F, []).
get_file_lines_acc(F, Acc) ->
    case file:read_line(F) of
        eof ->
            Acc;
        {ok, Data} ->
            get_file_lines_acc(F, [Data | Acc])
    end.

p(S, S2) ->
    io:format("~n~p:~n~p~n", [S, S2]).

int_to_month(Int) ->
    lists:nth(Int, [jan, feb, mar, apr, may, jun, jul, aug,
                    sep, oct, nov, dec]).

fat_processes() ->
    fat_processes(10).
fat_processes(C) ->
    L = lists:sort([{proplists:get_value(heap_size,L),
                     P,
                     proplists:get_value(initial_call, L),
                     proplists:get_value(current_function, L)}
                    ||{L,P} <- [{process_info(P), P} || P <- processes()]]),
    lists:reverse(lists:nthtail(length(L) - C, L)).

t(Mod, Fun, Args) ->
    dbg:stop_clear(),
    dbg:start(),
    dbg:tracer(),
    dbg:p(all,c),
    dbg:tpl(Mod, Fun, Args).
