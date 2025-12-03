module mod
   implicit none

   private
   public measure_joltage

contains
   pure function measure_joltage(line) result(joltage)
      implicit none
      character(*), intent(in) :: line
      integer(kind=8) :: c, i, j, k, joltage, current_joltage

      integer(kind=8) :: all_digits(12)

      all_digits = get_digits(line(1:12))

      current_joltage = get_joltage(all_digits, 1_8)
      joltage = 0

      do i = 13, len(line)
         c = digit(line(i:i))

         do j = 1, size(all_digits) - 1
            if (all_digits(j + 1) > all_digits(j)) then
               ! Shift all digits
               do k = j, size(all_digits) - 1
                  all_digits(k) = all_digits(k + 1)
               end do

               all_digits(size(all_digits)) = c
               exit
            end if
         end do

         if (c > all_digits(size(all_digits))) then
            all_digits(size(all_digits)) = c
         end if

         current_joltage = get_joltage(all_digits, 1_8)
         if (current_joltage > joltage) joltage = current_joltage
      end do
   end function measure_joltage

   pure recursive function get_joltage(all_digits, p) result(joltage)
      integer(kind=8), intent(in) :: all_digits(:)
      integer(kind=8), intent(in) :: p
      integer(kind=8) :: joltage, last_digit
      if (size(all_digits) == 0) then
         joltage = 0
      else
         last_digit = all_digits(size(all_digits))*p
         joltage = last_digit + get_joltage(all_digits(1:size(all_digits) - 1), p*10)
      end if
   end function get_joltage

   pure function digit(c) result(d)
      character(1), intent(in) :: c
      integer(kind=8) :: d
      d = ichar(c) - ichar('0')
   end function digit

   pure function get_digits(s) result(d)
      character(*), intent(in) :: s
      integer(kind=8) :: d(len(s))
      integer :: i

      do i = 1, len(s)
         d(i) = digit(s(i:i))
      end do
   end function get_digits
end module

program part1
   use mod, only: measure_joltage
   implicit none

   character(1000) :: buf
   integer :: ios
   integer(kind=8) :: result

   result = 0

   do
      read (*, *, iostat=ios) buf
      if (ios /= 0) exit

      result = result + measure_joltage(trim(buf))
   end do

   print *, result
end program part1
