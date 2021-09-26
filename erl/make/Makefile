SHELL := /bin/bash
.PHONY: all clean dirs app chmod data copy_data data_index table proto user_default map_block
ERL := erl
EBIN_DIRS := ebin
EBIN_DIRS_INTER := $(addprefix ../../, $(EBIN_DIRS))
MAKE_OPTS := {d, 'dummmmmy'}
DIALYZER_TOOL := dialyzer
DIALYZER_FILE := ./.dialyzer_plt
EDOC_OPTS=[{todo,true},{packages,false}]
EDOC_META=<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />
CLANG=zh
TEST=1
BETAROOT=/data/server/CN/beta/X1
STABLEROOT=/data/server/CN/stable/X1
PROTO_FILES := [\"src/proto/gen/gen_base.erl\",\"src/proto/gen/gen_proto.erl\",\"src/proto/gen/gen_proto_message.erl\"]
ROOT_DIR=$(shell pwd)

ifdef TEST
	MAKE_OPTS+=,{d, 'TEST'}, debug_info
endif

#all: dirs app chmod data copy_data table proto user_default

all: clean_ebin dirs chmod table proto copy_data user_default
	(./rebar3 compile)
	($(MAKE) app)
	(cp -f _build/default/lib/game/data/*.beam ebin)
	(cp -f _build/default/lib/*/ebin/* ebin)


simple:
	(rm -rf ebin/*; rm -rf *.dump)
	(./rebar3 compile)
	(cp -f _build/default/lib/game/data/*.beam ebin)
	(cp -f _build/default/lib/*/ebin/* ebin)

clean_ebin:
	(rm -rf ebin/*; rm -rf data/*;)

clean:
	@echo "清理 ..."
	(rm -rf ebin/*; rm -rf *.dump;)
	(./rebar3 clean)
	(rm -rf data/*)
	(rm -rf logs_game/*)
	(rm -rf proto/proto/*; rm -rf include/proto/*; rm -rf src/db/table/*)
	(rm -rf _build/default/lib/game/)

dirs:
	(mkdir -p data; mkdir -p ebin/)

app:
	(cp -f src/*.app ebin)
	(cp -f src/*/*.app ebin)

chmod:
	(cp -f gamectl ./script/gamectl)
	(sed -i "s#pwd#cd ..; pwd#g" `grep ROOT= -rl ./script/gamectl`)
	(chmod u+x ./script/gamectl;)
	(chmod u+x ./gamectl;)

data:
	(cp -fp data_$(CLANG)/*.erl data/)
	($(MAKE) data_index)

data_index:
	@echo "生成配置表索引..."
	@$(ERL) -pa $(EBIN_DIRS) -noinput \
		-eval "case make:files([\"src/util/config_index.erl\", \"src/util/data_index.erl\"]) of error -> halt(1); _ -> halt(0) end"
	@$(ERL) -smp 4 -pa $(EBIN_DIRS) -noinput \
		-eval "config_index:main()"

copy_data2: data simple
copy_data:
	($(MAKE) data)

table:
	(rm -rf ./src/db/table/*; chmod +x ./sql/gen_tab; ./sql/gen_tab ./sql/tab.conf ./include ./src/db/table)

scene:
	(rm -rf ./src/scene/gen_code/*; chmod +x ./script/scene/*; ./script/scene/gen_view_config ./src/scene/gen_code)

# 生成check_tail_recursion
tail_recursion_checker:
	@$(ERL) -pa $(EBIN_DIRS) -noinput \
		-eval "case make:files([\"src/util/tail_recursion_checker.erl\"]) of error -> halt(1); _ -> halt(0) end"

proto:# tail_recursion_checker
	@rm -rf ./ebin/*app
	@rm -fr ./proto/proto/*
	@rm -fr ./include/proto/*
	@rm -fr ./src/proto/proto/*.erl
	@chmod +x ./proto/gen_key
	@escript ./proto/gen_key ./proto/proto.conf ./include/proto
	@$(ERL) -pa $(EBIN_DIRS) -noinput \
		-eval "case make:files($(PROTO_FILES), [$(MAKE_OPTS)]) of error -> halt(1); _ -> halt(0) end"
	@$(ERL) -pa $(EBIN_DIRS) -noinput \
		-eval "gen_proto:gen()"
	(./rebar3 protobuf compile)

user_default:
	(chmod u+x ./script/dev/gen_user_default; ./script/dev/gen_user_default;)

data_check:
	(chmod u+x ./script/dev/gen_data_check; ./script/dev/gen_data_check;)
	@$(ERL) -pa $(EBIN_DIRS) -noinput \
		-eval "case make:files([\"src/util/data_check.erl\"]) of error -> halt(1); _ -> halt(0) end"
		
beta:
	(rm -rf $(BETAROOT)/config/*.*)	
	(rm -rf $(BETAROOT)/ebin/*.*)	
	(rm -rf $(BETAROOT)/sql/*.*)
	(cp -ru ./config/*.* $(BETAROOT)/config/ )
	(cp -ru ./ebin/*.beam $(BETAROOT)/ebin/ )
	(cp -ru ./sql/*.sql $(BETAROOT)/sql/ )
	(cp gamectl $(BETAROOT)/)
