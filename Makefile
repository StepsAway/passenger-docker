NAME = stepsaway/passenger
VERSION = 2.1.2

.PHONY: build_all clean clean_images \
	build_ruby230 build_ruby231 \
	build_ruby240 build_ruby241 build_ruby242 \
	build_jruby1726 \
	release test

all: build_all

build_all: \
	build_ruby230 \
	build_ruby231 \
	build_ruby240 \
	build_ruby241 \
	build_ruby242 \
	build_jruby1726

build_ruby230:
	rm -rf ruby230_image
	cp -pR image ruby230_image
	echo ruby230=1 >> ruby230_image/buildconfig
	echo final=1 >> ruby230_image/buildconfig
	echo jruby=0 >> ruby230_image/buildconfig
	sed -i -e "s/##IMAGE##/ruby23:0-$(VERSION)/" ruby230_image/Dockerfile
	docker build -t $(NAME)-ruby23:0-$(VERSION) --rm ruby230_image

build_ruby231:
	rm -rf ruby231_image
	cp -pR image ruby231_image
	echo ruby231=1 >> ruby231_image/buildconfig
	echo final=1 >> ruby231_image/buildconfig
	echo jruby=0 >> ruby231_image/buildconfig
	sed -i -e "s/##IMAGE##/ruby23:1-$(VERSION)/" ruby231_image/Dockerfile
	docker build -t $(NAME)-ruby23:1-$(VERSION) --rm ruby231_image

build_ruby240:
	rm -rf ruby240_image
	cp -pR image ruby240_image
	echo ruby240=1 >> ruby240_image/buildconfig
	echo final=1 >> ruby240_image/buildconfig
	echo jruby=0 >> ruby240_image/buildconfig
	sed -i -e "s/##IMAGE##/ruby24:0-$(VERSION)/" ruby240_image/Dockerfile
	docker build -t $(NAME)-ruby24:0-$(VERSION) --rm ruby240_image

build_ruby241:
	rm -rf ruby241_image
	cp -pR image ruby241_image
	echo ruby241=1 >> ruby241_image/buildconfig
	echo final=1 >> ruby241_image/buildconfig
	echo jruby=0 >> ruby241_image/buildconfig
	sed -i -e "s/##IMAGE##/ruby24:1-$(VERSION)/" ruby241_image/Dockerfile
	docker build -t $(NAME)-ruby24:1-$(VERSION) --rm ruby241_image

build_ruby242:
	rm -rf ruby242_image
	cp -pR image ruby242_image
	echo ruby242=1 >> ruby242_image/buildconfig
	echo final=1 >> ruby242_image/buildconfig
	echo jruby=0 >> ruby242_image/buildconfig
	sed -i -e "s/##IMAGE##/ruby24:2-$(VERSION)/" ruby242_image/Dockerfile
	docker build -t $(NAME)-ruby24:2-$(VERSION) --rm ruby242_image

build_jruby1726:
	rm -rf jruby1726_image
	cp -pR image jruby1726_image
	echo jruby1726=1 >> jruby1726_image/buildconfig
	echo final=1 >> jruby1726_image/buildconfig
	echo jruby=1 >> jruby1726_image/buildconfig
	sed -i -e "s/##IMAGE##/jruby17:26-$(VERSION)/" jruby1726_image/Dockerfile
	docker build -t $(NAME)-jruby17:26-$(VERSION) --rm jruby1726_image

clean:
	rm -rf ruby230_image
	rm -rf ruby231_image
	rm -rf ruby240_image
	rm -rf ruby241_image
	rm -rf ruby242_image
	rm -rf jruby1726_image

clean_images:
	@if docker images $(NAME)-ruby23:0-$(VERSION) | awk '{ print $$2 }' | grep -q -F 0-$(VERSION); then docker rmi -f $(NAME)-ruby23:0-$(VERSION) || true; fi
	@if docker images $(NAME)-ruby23:1-$(VERSION) | awk '{ print $$2 }' | grep -q -F 1-$(VERSION); then docker rmi -f $(NAME)-ruby23:1-$(VERSION) || true; fi
	@if docker images $(NAME)-ruby24:0-$(VERSION) | awk '{ print $$2 }' | grep -q -F 0-$(VERSION); then docker rmi -f $(NAME)-ruby24:0-$(VERSION) || true; fi
	@if docker images $(NAME)-ruby24:1-$(VERSION) | awk '{ print $$2 }' | grep -q -F 1-$(VERSION); then docker rmi -f $(NAME)-ruby24:1-$(VERSION) || true; fi
	@if docker images $(NAME)-ruby24:2-$(VERSION) | awk '{ print $$2 }' | grep -q -F 2-$(VERSION); then docker rmi -f $(NAME)-ruby24:2-$(VERSION) || true; fi
	@if docker images $(NAME)-jruby17:26-$(VERSION) | awk '{ print $$2 }' | grep -q -F 26-$(VERSION); then docker rmi -f $(NAME)-jruby17:26-$(VERSION) || true; fi

release: test
	@if ! docker images $(NAME)-ruby23:0-$(VERSION) | awk '{ print $$2 }' | grep -q -F 0-$(VERSION); then echo "$(NAME)-ruby23:0-$(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-ruby23:1-$(VERSION) | awk '{ print $$2 }' | grep -q -F 1-$(VERSION); then echo "$(NAME)-ruby23:1-$(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-ruby24:0-$(VERSION) | awk '{ print $$2 }' | grep -q -F 0-$(VERSION); then echo "$(NAME)-ruby24:0-$(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-ruby24:1-$(VERSION) | awk '{ print $$2 }' | grep -q -F 1-$(VERSION); then echo "$(NAME)-ruby24:1-$(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-ruby24:2-$(VERSION) | awk '{ print $$2 }' | grep -q -F 2-$(VERSION); then echo "$(NAME)-ruby24:2-$(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-jruby17:26-$(VERSION) | awk '{ print $$2 }' | grep -q -F 26-$(VERSION); then echo "$(NAME)-jruby17:26-$(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! head -n 1 Changelog.md | grep -q 'release date'; then echo 'Please note the release date in Changelog.md.' && false; fi
	docker push $(NAME)-ruby23:0-$(VERSION)
	docker push $(NAME)-ruby23:1-$(VERSION)
	docker push $(NAME)-ruby24:0-$(VERSION)
	docker push $(NAME)-ruby24:1-$(VERSION)
	docker push $(NAME)-ruby24:2-$(VERSION)
	docker push $(NAME)-jruby17:26-$(VERSION)
	@echo "*** Don't forget to create a tag. git tag $(VERSION) && git push origin $(VERSION)"

test:
	@if docker images $(NAME)-ruby23:0-$(VERSION) | awk '{ print $$2 }' | grep -q -F $(VERSION); then env NAME=$(NAME)-ruby23:0 RUBY='2.3.0' VERSION=$(VERSION) ./test/runner.sh; fi
	@if docker images $(NAME)-ruby23:1-$(VERSION) | awk '{ print $$2 }' | grep -q -F $(VERSION); then env NAME=$(NAME)-ruby23:1 RUBY='2.3.1' VERSION=$(VERSION) ./test/runner.sh; fi
	@if docker images $(NAME)-ruby24:0-$(VERSION) | awk '{ print $$2 }' | grep -q -F $(VERSION); then env NAME=$(NAME)-ruby24:0 RUBY='2.4.0' VERSION=$(VERSION) ./test/runner.sh; fi
	@if docker images $(NAME)-ruby24:1-$(VERSION) | awk '{ print $$2 }' | grep -q -F $(VERSION); then env NAME=$(NAME)-ruby24:1 RUBY='2.4.1' VERSION=$(VERSION) ./test/runner.sh; fi
	@if docker images $(NAME)-ruby24:2-$(VERSION) | awk '{ print $$2 }' | grep -q -F $(VERSION); then env NAME=$(NAME)-ruby24:2 RUBY='2.4.2' VERSION=$(VERSION) ./test/runner.sh; fi
	@if docker images $(NAME)-jruby17:26-$(VERSION) | awk '{ print $$2 }' | grep -q -F $(VERSION); then env NAME=$(NAME)-jruby17:26 RUBY='1.7.26' VERSION=$(VERSION) ./test/runner.sh; fi
