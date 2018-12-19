class Product < ApplicationRecord
  mount_uploaders :photos, PhotoUploader
end
