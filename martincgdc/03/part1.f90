module mod
   implicit none

   private
   public measure_joltage

contains
   pure function measure_joltage(line) result(joltage)
      implicit none
      character(*), intent(in) :: line
      integer :: a, b, c, i, joltage, current_joltage

      a = digit(line(1:1))
      b = digit(line(2:2))
      current_joltage = get_joltage(a, b)
      joltage = 0

      do i = 3, len(line)
         c = digit(line(i:i))

         if (b > a) then
            a = b
            b = c
         else if (c > b) then
            b = c
         end if

         current_joltage = get_joltage(a, b)
         if (current_joltage > joltage) joltage = current_joltage
      end do
   end function measure_joltage

   pure function get_joltage(a, b) result(joltage)
      integer, intent(in) :: a, b
      integer :: joltage
      joltage = a*10 + b
   end function get_joltage

   pure function digit(c) result(d)
      character(1), intent(in) :: c
      integer :: d
      d = ichar(c) - ichar('0')
   end function digit
end module

program part1
   use mod, only: measure_joltage
   implicit none

   character(1000) :: buf
   integer :: ios, result

   result = 0

   do
      read (*, *, iostat=ios) buf
      if (ios /= 0) exit

      result = result + measure_joltage(trim(buf))
   end do

   print *, result
end program part1
