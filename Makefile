NAME = stepsaway/passenger
VERSION = 1.0.3

.PHONY: build_all clean clean_images \
	build_ruby225 build_ruby230 build_ruby231 build_ruby240 build_jruby1726 \
	release test

build_all: \
	build_ruby225 \
	build_ruby230 \
	build_ruby231 \
	build_ruby240 \
	build_jruby1726

build_ruby225:
	rm -rf ruby225_image
	cp -pR image ruby225_image
	echo ruby225=1 >> ruby225_image/buildconfig
	echo final=1 >> ruby225_image/buildconfig
	echo jruby=0 >> ruby225_image/buildconfig
	sed -i -e "s/##IMAGE##/ruby22:5-$(VERSION)/" ruby225_image/Dockerfile
	docker build -t $(NAME)-ruby22:5-$(VERSION) --rm ruby225_image

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

build_jruby1726:
	rm -rf jruby1726_image
	cp -pR image jruby1726_image
	echo jruby1726=1 >> jruby1726_image/buildconfig
	echo final=1 >> jruby1726_image/buildconfig
	echo jruby=1 >> jruby1726_image/buildconfig
	sed -i -e "s/##IMAGE##/jruby17:26-$(VERSION)/" jruby1726_image/Dockerfile
	docker build -t $(NAME)-jruby17:26-$(VERSION) --rm jruby1726_image

clean:
	rm -rf ruby225_image
	rm -rf ruby230_image
	rm -rf ruby231_image
	rm -rf ruby240_image
	rm -rf jruby1726_image

clean_images:
	@if docker images $(NAME)-ruby22:5-$(VERSION) | awk '{ print $$2 }' | grep -q -F $(VERSION); then docker rmi -f $(NAME)-ruby22:5-$(VERSION) || true; fi
	@if docker images $(NAME)-ruby23:0-$(VERSION) | awk '{ print $$2 }' | grep -q -F 0-$(VERSION); then docker rmi -f $(NAME)-ruby23:0-$(VERSION) || true; fi
	@if docker images $(NAME)-ruby23:1-$(VERSION) | awk '{ print $$2 }' | grep -q -F 1-$(VERSION); then docker rmi -f $(NAME)-ruby23:1-$(VERSION) || true; fi
	@if docker images $(NAME)-ruby24:0-$(VERSION) | awk '{ print $$2 }' | grep -q -F 0-$(VERSION); then docker rmi -f $(NAME)-ruby24:0-$(VERSION) || true; fi
	@if docker images $(NAME)-jruby17:26-$(VERSION) | awk '{ print $$2 }' | grep -q -F 26-$(VERSION); then docker rmi -f $(NAME)-jruby17:26-$(VERSION) || true; fi

release: test
	@if ! docker images $(NAME)-ruby22:5-$(VERSION) | awk '{ print $$2 }' | grep -q -F 5-$(VERSION); then echo "$(NAME)-ruby23:5-$(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-ruby23:0-$(VERSION) | awk '{ print $$2 }' | grep -q -F 0-$(VERSION); then echo "$(NAME)-ruby23:0-$(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-ruby23:1-$(VERSION) | awk '{ print $$2 }' | grep -q -F 1-$(VERSION); then echo "$(NAME)-ruby23:1-$(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-ruby24:0-$(VERSION) | awk '{ print $$2 }' | grep -q -F 0-$(VERSION); then echo "$(NAME)-ruby24:0-$(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-jruby17:26-$(VERSION) | awk '{ print $$2 }' | grep -q -F 26-$(VERSION); then echo "$(NAME)-jruby17:26-$(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! head -n 1 Changelog.md | grep -q 'release date'; then echo 'Please note the release date in Changelog.md.' && false; fi
	docker push $(NAME)-ruby22:5-$(VERSION)
	docker push $(NAME)-ruby23:0-$(VERSION)
	docker push $(NAME)-ruby23:1-$(VERSION)
	docker push $(NAME)-ruby24:0-$(VERSION)
	docker push $(NAME)-jruby17:26-$(VERSION)
	@echo "*** Don't forget to create a tag. git tag $(VERSION) && git push origin $(VERSION)"

test:
	@if docker images $(NAME)-ruby22:5-$(VERSION) | awk '{ print $$2 }' | grep -q -F $(VERSION); then env NAME=$(NAME)-ruby22:5 RUBY='2.2.5' VERSION=$(VERSION) ./test/runner.sh; fi
	@if docker images $(NAME)-ruby23:0-$(VERSION) | awk '{ print $$2 }' | grep -q -F $(VERSION); then env NAME=$(NAME)-ruby23:0 RUBY='2.3.0' VERSION=$(VERSION) ./test/runner.sh; fi
	@if docker images $(NAME)-ruby23:1-$(VERSION) | awk '{ print $$2 }' | grep -q -F $(VERSION); then env NAME=$(NAME)-ruby23:1 RUBY='2.3.1' VERSION=$(VERSION) ./test/runner.sh; fi
	@if docker images $(NAME)-ruby24:0-$(VERSION) | awk '{ print $$2 }' | grep -q -F $(VERSION); then env NAME=$(NAME)-ruby24:0 RUBY='2.4.0' VERSION=$(VERSION) ./test/runner.sh; fi
	@if docker images $(NAME)-jruby17:26-$(VERSION) | awk '{ print $$2 }' | grep -q -F $(VERSION); then env NAME=$(NAME)-jruby17:26 RUBY='1.7.26' VERSION=$(VERSION) ./test/runner.sh; fi
