all: run

.PHONY: run
run: swift-from-go
	./swift-from-go

swift-from-go: main.go include/go_swift.h .build/arm64-apple-macosx/debug/libgo_swift.dylib
	go build

include/go_swift.h: include/go_swift.h.objc 
	grep -A6 'defined(SWIFT_EXTERN)' $^ > $@
	grep '^SWIFT_EXTERN' $^ >> $@

include/go_swift.h.objc: Sources/go-swift/go_swift.swift
	swiftc -emit-objc-header -emit-objc-header-path $@ $^

.build/arm64-apple-macosx/debug/libgo_swift.dylib: Sources/go-swift/go_swift.swift
	swift build

clean:
	rm -f include/go_swift.h include/go_swift.h.objc
	rm -rf .build
	rm -f swift-from-go
