require 'pathname'
require 'cfpropertylist'

path = Pathname.new('~/Library/Safari/Bookmarks.plist').expand_path
plist = CFPropertyList::List.new(file: path)
data = CFPropertyList.native_types(plist.value)
bookmarks = data['Children']

folders = bookmarks.select { |b| b['WebBookmarkType'] == 'WebBookmarkTypeList' }
                   .sort_by! { |dir| dir['Title'].downcase }

leafs = bookmarks.select { |b| b['WebBookmarkType'] == 'WebBookmarkTypeLeaf' }
                 .sort_by! { |l| l['URIDictionary']['title'].downcase }

data['Children'] = []
data['Children'].concat(folders)
data['Children'].concat(leafs)

plist.value = CFPropertyList.guess(data)
plist.save

puts "Sorted #{folders.count} folders"
puts "Sorted #{leafs.count} leafs"
